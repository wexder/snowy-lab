import QtQuick
import qs.config

// Hover/press feedback plus click handling in one place, so widgets do not each
// re-implement a MouseArea with their own colour rules.
MouseArea {
    id: root

    property color hoverColor: Theme.palette.hover
    property color pressColor: Theme.palette.pressed
    property real radius: Theme.radius.normal
    property bool active: false
    property color activeColor: Theme.palette.accent

    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        z: -1
        color: {
            if (root.active)
                return root.activeColor;
            if (root.pressed)
                return root.pressColor;
            if (root.containsMouse)
                return root.hoverColor;
            return "transparent";
        }

        Behavior on color {
            ColorAnimation {
                duration: Theme.duration.fast
            }
        }
    }
}
