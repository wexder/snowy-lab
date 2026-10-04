import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config

// A pill toggle with an optional chevron that expands a detail list below.
StyledRect {
    id: root

    property string icon
    property string label
    property string sublabel
    property bool active: false
    property bool expandable: false
    property bool expanded: false

    signal toggled
    signal expandRequested

    Layout.fillWidth: true
    implicitHeight: 52

    radius: Theme.radius.normal
    color: active ? Theme.palette.accent : Theme.palette.surface

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacing.large
        anchors.rightMargin: root.expandable ? 0 : Theme.spacing.large
        spacing: Theme.spacing.normal

        Icon {
            text: root.icon
            sizeMultiplier: 1.1
            color: root.active ? Theme.palette.onAccent : Theme.palette.text
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                Layout.fillWidth: true
                text: root.label
                font.pointSize: Theme.font.small
                font.bold: true
                color: root.active ? Theme.palette.onAccent : Theme.palette.text
            }

            StyledText {
                Layout.fillWidth: true
                visible: root.sublabel !== ""
                text: root.sublabel
                font.pointSize: Theme.font.tiny
                color: root.active ? Qt.alpha(Theme.palette.onAccent, 0.75) : Theme.palette.muted
            }
        }

        IconButton {
            visible: root.expandable
            icon: root.expanded ? "󰅃" : "󰅀"
            iconSize: 0.8
            iconColor: root.active ? Theme.palette.onAccent : Theme.palette.subtext
            padding: Theme.spacing.normal
            onClicked: root.expandRequested()
        }
    }

    // Stops short of the chevron button so the two do not fight over clicks.
    StateLayer {
        anchors.fill: undefined
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width - (root.expandable ? 44 : 0)
        radius: Theme.radius.normal
        hoverColor: root.active ? Qt.alpha("#FFFFFF", 0.12) : Theme.palette.hover
        onClicked: root.toggled()
    }
}
