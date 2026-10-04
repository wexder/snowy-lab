import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.config
import qs.services
import "widgets" as Widgets

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: bar

        required property ShellScreen modelData
        screen: modelData

        color: "transparent"
        implicitHeight: Theme.barHeight
        exclusiveZone: Theme.barHeight

        WlrLayershell.namespace: "quickshell:bar"

        anchors {
            top: Config.bar.onTop
            bottom: !Config.bar.onTop
            left: true
            right: true
        }

        StyledRect {
            anchors.fill: parent
            radius: 0
            color: Theme.palette.background

            // Hairline separating the bar from the desktop.
            Rectangle {
                width: parent.width
                height: 1
                color: Qt.alpha(Theme.palette.border, 0.6)
                anchors.top: Config.bar.onTop ? undefined : parent.top
                anchors.bottom: Config.bar.onTop ? parent.bottom : undefined
            }
        }

        // Three independently anchored groups rather than a single RowLayout:
        // with fillWidth spacers the centre group only lands in the middle when
        // the left and right groups happen to be the same width.
        Item {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacing.small
            anchors.rightMargin: Theme.spacing.small

            RowLayout {
                id: left
                spacing: Theme.spacing.tiny
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                Widgets.LauncherButton {
                    id: launcherButton
                }

                Widgets.Workspaces {
                    id: workspaces
                    screen: bar.modelData
                }

                Widgets.ActiveWindow {
                    // Whatever is left between the workspaces and the centre
                    // group, so a long title never pushes the clock off centre.
                    availableWidth: Math.max(0, bar.width / 2 - centre.width / 2 - launcherButton.width - workspaces.width - Theme.spacing.giant)
                }
            }

            RowLayout {
                id: centre
                spacing: Theme.spacing.tiny
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Widgets.Clock {
                    onToggleCalendar: Panels.toggle("calendar")
                }
            }

            RowLayout {
                id: right
                spacing: Theme.spacing.tiny
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Widgets.Media {}
                Widgets.Tray {}
                Widgets.Resources {}
                Widgets.KeyboardLayout {}
                Widgets.Network {
                    onRequestControlCenter: Panels.toggle("controlCenter")
                }
                Widgets.Bluetooth {
                    onRequestControlCenter: Panels.toggle("controlCenter")
                }
                Widgets.Audio {
                    onRequestOsd: Osd.show("volume")
                }
                Widgets.Battery {}
                Widgets.Notifications {
                    onToggleCenter: Panels.toggle("notificationCenter")
                }
            }
        }
    }
}
