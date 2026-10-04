import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import qs.components
import qs.config
import qs.services as Services

OverlayPanel {
    id: root

    shown: Services.Panels.notificationCenter
    onDismissed: Services.Panels.close("notificationCenter")

    placement: "topRight"
    panelWidth: 420
    // Sized to content: an empty centre should not be a tall empty box.
    panelHeight: Services.Notifs.count === 0 ? 260 : Math.max(260, Math.min(620, header.height + list.contentHeight + Theme.spacing.large * 3))

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.large
        spacing: Theme.spacing.normal

        RowLayout {
            id: header

            Layout.fillWidth: true
            spacing: Theme.spacing.normal

            StyledText {
                Layout.fillWidth: true
                text: "Notifications"
                font.pointSize: Theme.font.title
                font.bold: true
            }

            IconButton {
                icon: Services.Notifs.doNotDisturb ? "󰂛" : "󰂚"
                iconColor: Services.Notifs.doNotDisturb ? Theme.palette.warning : Theme.palette.subtext
                onClicked: Services.Notifs.toggleDnd()
            }

            IconButton {
                icon: "󰎟"
                iconColor: Theme.palette.subtext
                visible: Services.Notifs.count > 0
                onClicked: Services.Notifs.clear()
            }
        }

        StyledText {
            visible: Services.Notifs.doNotDisturb
            Layout.fillWidth: true
            text: "Do not disturb is on — popups are suppressed."
            font.pointSize: Theme.font.small
            color: Theme.palette.warning
            wrapMode: Text.WordWrap
        }

        // Empty state. Each child fills the width and centres its own text —
        // Layout.alignment would centre against the column's content width,
        // which collapses to the width of the widest child.
        ColumnLayout {
            visible: Services.Notifs.count === 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacing.small

            Item {
                Layout.fillHeight: true
            }

            Icon {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: "󰂜"
                sizeMultiplier: 2.5
                color: Theme.palette.muted
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: "All caught up"
                color: Theme.palette.muted
            }

            Item {
                Layout.fillHeight: true
            }
        }

        ListView {
            id: list

            visible: Services.Notifs.count > 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            spacing: Theme.spacing.normal

            // Diffed, so dismissing one entry does not rebuild the whole list.
            model: ScriptModel {
                values: [...Services.Notifs.list]
            }

            remove: Transition {
                NumberAnimation {
                    properties: "opacity"
                    to: 0
                    duration: Theme.duration.fast
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: Theme.duration.normal
                    easing.type: Easing.OutCubic
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: list.contentHeight > list.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            }

            delegate: NotificationCard {
                required property var modelData
                notification: modelData
                showAge: true
                width: list.width - (list.ScrollBar.vertical.visible ? Theme.spacing.large : 0)
            }
        }
    }
}
