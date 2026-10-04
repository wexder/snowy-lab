import QtQuick
import qs.config

Item {
    id: root

    property string icon
    property real iconSize: 1
    property color iconColor: Theme.palette.text
    property alias hovered: state.containsMouse
    property alias acceptedButtons: state.acceptedButtons
    property int padding: Theme.spacing.small

    signal clicked(var event)

    implicitWidth: glyph.implicitWidth + padding * 2
    implicitHeight: glyph.implicitHeight + padding * 2

    Icon {
        id: glyph
        anchors.centerIn: parent
        text: root.icon
        color: root.iconColor
        sizeMultiplier: root.iconSize
    }

    StateLayer {
        id: state
        radius: Theme.radius.small
        onClicked: event => root.clicked(event)
    }
}
