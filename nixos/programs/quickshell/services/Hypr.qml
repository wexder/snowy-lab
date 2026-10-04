pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

// Thin, sorted view over Hyprland's state. Everything here is event driven —
// no `hyprctl` polling.
Singleton {
    id: root

    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel
    readonly property string activeTitle: activeToplevel?.title ?? ""
    readonly property string activeClass: activeToplevel?.lastIpcObject?.class ?? ""

    // The ShellScreen the focused monitor corresponds to, for placing panels.
    readonly property ShellScreen focusedScreen: {
        const name = Hyprland.focusedMonitor?.name;
        return Quickshell.screens.find(screen => screen.name === name) ?? Quickshell.screens[0] ?? null;
    }

    readonly property list<HyprlandWorkspace> workspaces: [...Hyprland.workspaces.values]
        .filter(ws => ws.id > 0)
        .sort((a, b) => a.id - b.id)

    // Persistent 1..N slots so the bar does not jump around as workspaces are
    // created and destroyed.
    readonly property int workspaceCount: Math.max(5, ...workspaces.map(ws => ws.id))

    function workspacesFor(monitor: HyprlandMonitor): list<HyprlandWorkspace> {
        return workspaces.filter(ws => ws.monitor === monitor);
    }

    // Finds the address of a window belonging to an app, given the names a
    // sender might identify itself by (a desktop entry id, an app name). The
    // comparison is deliberately loose at one end only: senders say "Slack"
    // where the class is "slack", and reverse-DNS ids match the class whole.
    // Tails are never compared to each other, because half the reverse-DNS ids
    // out there end in "desktop".
    function findWindow(names: list<string>): string {
        const norm = value => (value ?? "").toLowerCase().replace(/[^a-z0-9.]/g, "");
        const tail = value => norm(value).split(".").pop();

        const wanted = names.map(norm).filter(name => !!name);
        if (!wanted.length)
            return "";

        for (const toplevel of Hyprland.toplevels.values) {
            const cls = norm(toplevel.lastIpcObject?.class);
            if (!cls)
                continue;
            if (wanted.some(name => name === cls || name === tail(cls) || tail(name) === cls))
                return toplevel.address;
        }
        return "";
    }

    function workspaceById(id: int): HyprlandWorkspace {
        return workspaces.find(ws => ws.id === id) ?? null;
    }

    // Hyprland's Lua config mode does not take the classic dispatcher strings
    // at all: `dispatch` there is shorthand for `hl.dispatch(...)`, which wants
    // a dispatcher object (`hl.dsp.focus{...}`), not a command line. So each
    // action needs both spellings, and this is the one place that knows it.
    function dispatch(classic: string, lua: string): void {
        Hyprland.dispatch(Hyprland.usingLua ? lua : classic);
    }

    function switchTo(id: int): void {
        root.dispatch(`workspace ${id}`, `hl.dsp.focus({ workspace = ${id} })`);
    }

    function moveTo(id: int): void {
        root.dispatch(`movetoworkspace ${id}`, `hl.dsp.window.move({ workspace = ${id} })`);
    }

    // HyprlandToplevel.address comes without the "0x" that Hyprland's own
    // address: selector insists on, so it is put back here.
    function focusWindow(address: string): void {
        if (!address)
            return;
        const selector = `address:${address.startsWith("0x") ? address : "0x" + address}`;
        root.dispatch(`focuswindow ${selector}`, `hl.dsp.focus({ window = "${selector}" })`);
    }
}
