import QtQuick
import QtQuick.Controls
import qs.config

Slider {
    id: root

    property color trackColor: Theme.palette.surfaceAlt
    property color fillColor: Theme.palette.accent

    implicitHeight: 18
    from: 0
    to: 1

    background: StyledRect {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: root.availableWidth
        height: 6
        radius: Theme.radius.full
        color: root.trackColor

        StyledRect {
            width: root.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: root.fillColor
        }
    }

    handle: StyledRect {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 14
        implicitHeight: 14
        radius: Theme.radius.full
        color: root.pressed ? root.fillColor : Theme.palette.text
        scale: root.pressed ? 1.15 : 1

        Behavior on scale {
            NumberAnimation {
                duration: Theme.duration.fast
                easing.type: Easing.OutCubic
            }
        }
    }
}
