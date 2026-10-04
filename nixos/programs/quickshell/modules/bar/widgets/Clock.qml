import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services

BarBlock {
    id: root

    signal toggleCalendar

    tooltipText: Time.dateLong
    onClicked: root.toggleCalendar()

    Icon {
        text: "󰥔"
        color: Theme.palette.accent
        sizeMultiplier: 0.85
    }

    StyledText {
        text: Time.time
        font.pointSize: Theme.font.normal
        font.bold: true
    }

    StyledText {
        text: Time.date
        color: Theme.palette.muted
        font.pointSize: Theme.font.small
    }
}
