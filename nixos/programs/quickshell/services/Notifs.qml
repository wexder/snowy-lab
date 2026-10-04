pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import qs.config
import qs.services
import QtQuick

// Owns the notification server for the whole shell: popups and the notification
// centre are both views over this one list.
Singleton {
    id: root

    // Newest first. Notifications stay here after their popup expires.
    property list<Notification> list: []
    // Subset currently shown as a popup.
    property list<Notification> popups: []

    property bool doNotDisturb: false

    // Arrival timestamps, keyed by notification id — the protocol does not
    // carry one, and the notification centre needs to show ages.
    property var times: ({})

    readonly property int count: list.length
    readonly property bool hasUrgent: list.some(n => n.urgency === NotificationUrgency.Critical)
    readonly property string icon: doNotDisturb ? "󰂛" : count > 0 ? "󰂚" : "󰂜"

    signal notified(notification: Notification)

    function dismiss(notification: Notification): void {
        root.popups = root.popups.filter(n => n !== notification);
    }

    // Closes the notification properly, so the sending app is told it was
    // dismissed rather than the entry just vanishing from our list.
    function remove(notification: Notification): void {
        notification.dismiss();
    }

    function clear(): void {
        for (const notification of [...root.list])
            notification.dismiss();
    }

    function ageText(notification: Notification): string {
        const at = root.times[notification.id];
        if (!at)
            return "";
        return Time.relative(Math.floor((Time.now.getTime() - at) / 1000));
    }

    function clearPopups(): void {
        root.popups = [];
    }

    function toggleDnd(): void {
        root.doNotDisturb = !root.doNotDisturb;
        if (root.doNotDisturb)
            root.clearPopups();
    }

    // The "default" action is the one invoked by clicking the notification
    // body. The spec says it must never be drawn as a button, and Electron apps
    // (Slack, Discord, Element) attach one to every single message — so
    // treating it like a real action made every Slack message look actionable.
    function displayActions(notification: Notification): list<var> {
        if (!notification)
            return [];
        return notification.actions.filter(action => action.identifier !== "default");
    }

    function defaultAction(notification: Notification): var {
        return notification?.actions.find(action => action.identifier === "default") ?? null;
    }

    // The window a notification came from, if it is still open.
    function windowFor(notification: Notification): string {
        if (!notification)
            return "";
        return Hypr.findWindow([notification.desktopEntry, notification.appName]);
    }

    function canActivate(notification: Notification): bool {
        return !!root.defaultAction(notification) || !!root.windowFor(notification);
    }

    // What clicking the body does. Invoking the default action is only half of
    // it: under Wayland the app cannot raise itself without an activation
    // token, so Slack and the other Electron clients handle the click without
    // ever coming to the front. Focusing the window here is what the user
    // actually asked for by clicking.
    function activate(notification: Notification): void {
        if (!notification)
            return;

        const address = root.windowFor(notification);
        root.defaultAction(notification)?.invoke();
        if (address)
            Hypr.focusWindow(address);

        root.dismiss(notification);
        // Clicking through to an app means you are done with the shell's own
        // surfaces; leaving the centre open would just cover what you focused.
        Panels.closeAll();
    }

    // Notification.appIcon is often empty; fall back to the desktop entry.
    function iconFor(notification: Notification): string {
        if (notification.appIcon)
            return notification.appIcon;
        const entry = DesktopEntries.heuristicLookup(notification.appName);
        return entry?.icon ?? "";
    }

    NotificationServer {
        id: server

        keepOnReload: false
        // Advertised over DBus. Senders check these: blueman, for one, falls
        // back to its own GTK dialog unless the daemon claims both.
        bodySupported: true
        actionsSupported: true
        actionIconsSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notification => {
            notification.tracked = true;

            const times = root.times;
            times[notification.id] = Date.now();
            root.times = times;

            root.list = [notification, ...root.list];
            // The popup stack is capped: a burst of notifications should not
            // paper over the whole screen. The overflow stays in the centre.
            if (!root.doNotDisturb)
                root.popups = [notification, ...root.popups].slice(0, Config.behaviour.maxPopups);

            root.notified(notification);

            notification.closed.connect(() => {
                root.popups = root.popups.filter(n => n !== notification);
                root.list = root.list.filter(n => n !== notification);
            });
        }
    }

    // A popup that asks a question has to wait for the answer. Bluetooth
    // pairing confirmations are the motivating case: they arrive with actions
    // and normal urgency, and expiring them after a few seconds loses the
    // prompt entirely.
    //
    // "Has actions" alone is far too broad a test — chat apps hang actions off
    // every routine message, which pinned every Slack message on screen for
    // good. A real prompt also asks not to expire: blueman passes timeout 0 on
    // each of its pairing and authorization prompts (blueman/main/applet/
    // BluezAgent.py). So both have to hold: something the user can answer, and
    // an app that said it wants to wait for that answer.
    function persists(notification: Notification): bool {
        if (notification.urgency === NotificationUrgency.Critical)
            return true;
        if (!Config.behaviour.persistActionable)
            return false;
        // 0 means "never expire" per the spec; -1 means "server decides".
        return notification.expireTimeout === 0 && root.displayActions(notification).length > 0;
    }

    // How long a popup stays on screen, in milliseconds.
    //
    // Apps ask for wildly inconsistent timeouts (and some ask for "never"), so
    // by default their request is ignored in favour of one consistent value —
    // this is what mako's `ignore-timeout` did. Set behaviour.ignoreAppTimeout
    // to false to honour the app instead, still clamped so nothing can pin a
    // popup on screen forever.
    function timeoutFor(notification: Notification): int {
        const fallback = Config.behaviour.notificationTimeout;
        if (Config.behaviour.ignoreAppTimeout)
            return fallback;
        // 0 means "never expire" per the spec; treat it as the maximum.
        if (notification.expireTimeout <= 0)
            return Config.behaviour.maxNotificationTimeout;
        return Math.min(notification.expireTimeout, Config.behaviour.maxNotificationTimeout);
    }

    // Expiry itself lives on the popup delegate (modules/notifications/
    // NotificationPopups.qml), driven by the same animation that draws the
    // countdown bar — one clock, so the bar and the dismissal cannot drift
    // apart, and hovering pauses both. `persists` and `timeoutFor` above stay
    // here because they are policy, not presentation. The entry stays in
    // `list` for the notification centre either way.
}
