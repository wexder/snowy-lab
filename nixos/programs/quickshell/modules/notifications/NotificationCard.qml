import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.components
import qs.config
import qs.services as Services

// One notification, shared by the popup stack and the notification centre.
StyledRect {
    id: root

    // Null for a frame while a delegate is torn down, so every read below is
    // null-safe rather than logging a TypeError on each dismissal.
    required property Notification notification
    property bool showAge: false

    // Fraction of the popup's lifetime left, 1 down to 0. Negative means this
    // card has no countdown to show — the notification centre, and popups that
    // stay up until they are answered.
    property real progress: -1

    readonly property bool showProgress: progress >= 0
    readonly property int progressHeight: 3

    // Excludes the "default" action, which belongs on the card body rather
    // than in a button row.
    readonly property var actions: Services.Notifs.displayActions(notification)
    readonly property var primaryAction: Services.Notifs.defaultAction(notification)

    readonly property bool critical: notification?.urgency === NotificationUrgency.Critical
    readonly property string iconSource: {
        if (!notification)
            return "";
        if (notification.image)
            return notification.image;
        const icon = Services.Notifs.iconFor(notification);
        return icon ? Quickshell.iconPath(icon, true) : "";
    }

    implicitHeight: layout.implicitHeight + Theme.spacing.large * 2 + (showProgress ? progressHeight + Theme.spacing.normal : 0)

    color: Theme.palette.elevated
    radius: Theme.radius.normal
    border.width: 1
    border.color: critical ? Theme.palette.urgent : Theme.palette.border

    // Accent stripe for critical notifications.
    StyledRect {
        visible: root.critical
        width: 3
        radius: 0
        color: Theme.palette.urgent
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            margins: 1
        }
    }

    // Clicking the body invokes the "default" action — what the spec reserves
    // it for, and the only way to reach it now that it is not a button — and
    // raises the sending window, which the app cannot do for itself.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        enabled: Services.Notifs.canActivate(root.notification)
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: Services.Notifs.activate(root.notification)
    }

    ColumnLayout {
        id: layout
        spacing: Theme.spacing.small
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Theme.spacing.large
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.normal

            IconImage {
                implicitSize: Theme.font.iconLarge
                source: root.iconSource
                visible: source !== ""
                Layout.alignment: Qt.AlignTop
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.small

                    StyledText {
                        Layout.fillWidth: true
                        text: root.notification?.summary ?? ""
                        font.pointSize: Theme.font.normal
                        font.bold: true
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                    }

                    StyledText {
                        visible: root.showAge
                        text: root.notification ? Services.Notifs.ageText(root.notification) : ""
                        font.pointSize: Theme.font.tiny
                        color: Theme.palette.muted
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: root.notification?.appName ?? ""
                    font.pointSize: Theme.font.tiny
                    color: Theme.palette.muted
                }
            }

            IconButton {
                icon: "󰅖"
                iconSize: 0.75
                iconColor: Theme.palette.muted
                Layout.alignment: Qt.AlignTop
                onClicked: if (root.notification) Services.Notifs.remove(root.notification)
            }
        }

        StyledText {
            Layout.fillWidth: true
            visible: text !== ""
            text: root.notification?.body ?? ""
            textFormat: Text.MarkdownText
            color: Theme.palette.subtext
            font.pointSize: Theme.font.small
            wrapMode: Text.WordWrap
            maximumLineCount: 6
            onLinkActivated: link => Quickshell.execDetached(["xdg-open", link])
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: Theme.spacing.tiny
            visible: root.actions.length > 0
            spacing: Theme.spacing.small

            Repeater {
                model: root.actions

                delegate: StyledRect {
                    required property NotificationAction modelData

                    implicitWidth: actionLabel.implicitWidth + Theme.spacing.large * 2
                    implicitHeight: actionLabel.implicitHeight + Theme.spacing.normal

                    radius: Theme.radius.small
                    color: actionState.containsMouse ? Theme.palette.surfaceAlt : Theme.palette.surface

                    StyledText {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: parent.modelData.text
                        font.pointSize: Theme.font.small
                        color: Theme.palette.text
                    }

                    StateLayer {
                        id: actionState
                        radius: Theme.radius.small
                        hoverColor: "transparent"
                        pressColor: "transparent"
                        onClicked: parent.modelData.invoke()
                    }
                }
            }
        }
    }

    // Countdown to dismissal. Inset to the content margins and pill-shaped
    // rather than full-bleed: a bar running to the card's edge shows square
    // ends over the rounded corners.
    Item {
        id: progressTrack

        visible: root.showProgress
        height: root.progressHeight

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: Theme.spacing.large
            rightMargin: Theme.spacing.large
            bottomMargin: Theme.spacing.normal
        }

        StyledRect {
            anchors.fill: parent
            radius: Theme.radius.full
            color: Qt.alpha(Theme.palette.border, 0.5)
        }

        StyledRect {
            height: parent.height
            width: parent.width * Math.max(0, Math.min(1, root.progress))
            radius: Theme.radius.full
            color: root.critical ? Theme.palette.urgent : Theme.palette.accent
        }
    }
}
