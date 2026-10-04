import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.config
import qs.services as Services

// Popup stack in the top-right of the focused monitor.
PanelWindow {
    id: root

    screen: Services.Hypr.focusedScreen
    visible: Services.Notifs.popups.length > 0
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:notifications"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    implicitWidth: 400
    // A Column sizes itself to its children. A ListView cannot be used here:
    // it is virtualised, so deriving the window height from its contentHeight
    // while its own height comes from the window leaves it with nothing to
    // lay out and nothing renders.
    implicitHeight: Math.max(1, column.implicitHeight)

    // The window must shrink in step with the move transition below. Snapping
    // straight to the new height clips the card that is still sliding up into
    // the gap left by a dismissed popup.
    Behavior on implicitHeight {
        NumberAnimation {
            duration: Theme.duration.normal
            easing.type: Easing.OutCubic
        }
    }

    anchors {
        top: true
        right: true
    }

    margins {
        // Clears the bar: this is an overlay layer with exclusionMode Ignore,
        // so `top` is the top of the screen, not the top of the free area.
        top: Theme.barInsetTop + Theme.spacing.normal
        right: Theme.spacing.large
    }

    // Only the stack takes clicks; everything around it stays click-through.
    mask: Region {
        item: column
    }

    Column {
        id: column

        width: parent.width
        spacing: Theme.spacing.normal

        // Only `move` is a view transition. The entry animation lives on the
        // delegate instead: an `add` Transition with `from:` values strands
        // opacity at 0 when several popups arrive in the same frame, because
        // the concurrent `move` transition fights it.
        //
        // This slides the cards below a dismissed popup up to close the gap,
        // rather than every card replaying its entry animation.
        move: Transition {
            NumberAnimation {
                properties: "y"
                duration: Theme.duration.normal
                easing.type: Easing.OutCubic
            }
        }

        Repeater {
            // ScriptModel diffs the list rather than replacing it wholesale, so
            // dismissing one popup does not tear down and rebuild the rest.
            model: ScriptModel {
                values: [...Services.Notifs.popups]
            }

            delegate: NotificationCard {
                id: card

                required property var modelData
                notification: modelData

                width: column.width

                // Popups that ask a question wait for the answer, so they have
                // no countdown to draw.
                readonly property bool persistent: Services.Notifs.persists(modelData)

                // The countdown both draws the bar and dismisses the popup, so
                // the bar cannot finish while the popup lingers, or vice versa.
                // Hovering pauses it: a notification you are still reading
                // should not time out under the cursor.
                NumberAnimation on progress {
                    running: !card.persistent
                    paused: hover.hovered
                    from: 1
                    to: 0
                    duration: Services.Notifs.timeoutFor(card.modelData)
                    onFinished: Services.Notifs.dismiss(card.notification)
                }

                HoverHandler {
                    id: hover
                }

                // Runs once per card. ScriptModel keeps existing delegates
                // alive, so dismissing one popup no longer replays this for
                // every other card on screen.
                //
                // Only opacity and scale are animated: the Column positioner
                // owns x and y during its move transition and will interrupt a
                // Behavior on either, stranding the card off to one side.
                opacity: 0
                scale: 0.94
                Component.onCompleted: {
                    opacity = 1;
                    scale = 1;
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.duration.normal
                    }
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: Theme.duration.normal
                        easing.type: Easing.OutCubic
                    }
                }

                // Middle-click dismisses just the popup, leaving it in the centre.
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.MiddleButton
                    onClicked: Services.Notifs.dismiss(card.notification)
                }
            }
        }
    }
}
