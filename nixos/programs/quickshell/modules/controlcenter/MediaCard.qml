import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.config
import qs.services as Services

StyledRect {
    id: root

    Layout.fillWidth: true
    visible: Services.Media.hasPlayer
    implicitHeight: 78

    radius: Theme.radius.normal
    color: Theme.palette.surface

    Component.onCompleted: Services.Media.subscribers++
    Component.onDestruction: Services.Media.subscribers--

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.large
        spacing: Theme.spacing.large

        ClippingRectangle {
            implicitWidth: 46
            implicitHeight: 46
            radius: Theme.radius.small
            color: Theme.palette.surfaceAlt
            visible: Services.Media.artUrl !== ""

            Image {
                anchors.fill: parent
                source: Services.Media.artUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.tiny

            StyledText {
                Layout.fillWidth: true
                text: Services.Media.title || "Nothing playing"
                font.pointSize: Theme.font.small
                font.bold: true
            }

            StyledText {
                Layout.fillWidth: true
                text: Services.Media.artist
                font.pointSize: Theme.font.tiny
                color: Theme.palette.muted
                visible: text !== ""
            }

            StyledRect {
                Layout.fillWidth: true
                Layout.topMargin: Theme.spacing.tiny
                visible: Services.Media.progress >= 0
                implicitHeight: 3
                radius: Theme.radius.full
                color: Theme.palette.surfaceAlt

                StyledRect {
                    width: parent.width * Math.max(0, Services.Media.progress)
                    height: parent.height
                    radius: parent.radius
                    color: Theme.palette.accent
                }
            }
        }

        RowLayout {
            spacing: 0

            IconButton {
                icon: "󰒮"
                iconColor: Theme.palette.subtext
                onClicked: Services.Media.previous()
            }

            IconButton {
                icon: Services.Media.icon
                iconSize: 1.2
                iconColor: Theme.palette.accent
                onClicked: Services.Media.playPause()
            }

            IconButton {
                icon: "󰒭"
                iconColor: Theme.palette.subtext
                onClicked: Services.Media.next()
            }
        }
    }
}
