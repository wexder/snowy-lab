import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config

RowLayout {
    id: root

    property string icon
    property real value: 0
    property bool dimmed: false

    signal moved(real value)
    signal iconClicked

    Layout.fillWidth: true
    spacing: Theme.spacing.normal

    IconButton {
        icon: root.icon
        iconColor: root.dimmed ? Theme.palette.muted : Theme.palette.text
        onClicked: root.iconClicked()
    }

    StyledSlider {
        Layout.fillWidth: true
        value: root.value
        fillColor: root.dimmed ? Theme.palette.muted : Theme.palette.accent
        onMoved: root.moved(value)
    }

    StyledText {
        text: `${Math.round(root.value * 100)}%`
        font.pointSize: Theme.font.tiny
        color: Theme.palette.muted
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 34
    }
}
