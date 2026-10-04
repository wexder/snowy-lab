import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config

// A single bar item: content, hover feedback, an optional tooltip and click or
// scroll handling. Every widget in the bar is built from this.
Item {
    id: root

    default property alias content: layout.data
    property string tooltipText
    property int padding: Theme.spacing.normal
    property int spacing: Theme.spacing.small
    property bool active: false
    property bool interactive: true

    signal clicked(var event)
    signal wheel(var event)

    implicitWidth: layout.implicitWidth + padding * 2
    implicitHeight: Theme.barHeight
    Layout.preferredWidth: implicitWidth
    Layout.fillHeight: true

    StyledRect {
        anchors.fill: parent
        anchors.topMargin: Theme.spacing.small
        anchors.bottomMargin: Theme.spacing.small
        radius: Theme.radius.small
        color: {
            if (root.active)
                return Qt.alpha(Theme.palette.accent, 0.22);
            if (!root.interactive)
                return "transparent";
            if (mouse.pressed)
                return Theme.palette.pressed;
            if (mouse.containsMouse)
                return Theme.palette.hover;
            return "transparent";
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: root.spacing
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: event => root.clicked(event)
        onWheel: event => root.wheel(event)
    }

    Tooltip {
        relativeItem: root.tooltipText && mouse.containsMouse ? root : null
        text: root.tooltipText
    }
}
