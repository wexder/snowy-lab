import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services

// CPU and memory. Only polls /proc while the widget is on screen.
BarBlock {
    id: root

    tooltipText: `CPU ${Math.round(SysInfo.cpuUsage * 100)}%  ·  RAM ${SysInfo.memoryUsedText} / ${SysInfo.memoryTotalText}`

    Component.onCompleted: SysInfo.subscribers++
    Component.onDestruction: SysInfo.subscribers--

    Icon {
        text: "󰻠"
        sizeMultiplier: 0.85
        color: SysInfo.cpuUsage > 0.85 ? Theme.palette.error : Theme.palette.accentAlt
    }

    StyledText {
        text: `${Math.round(SysInfo.cpuUsage * 100)}%`
        font.pointSize: Theme.font.small
        color: Theme.palette.subtext
    }

    Icon {
        text: "󰍛"
        sizeMultiplier: 0.85
        color: SysInfo.memoryUsage > 0.9 ? Theme.palette.error : Theme.palette.accentAlt
    }

    StyledText {
        text: `${Math.round(SysInfo.memoryUsage * 100)}%`
        font.pointSize: Theme.font.small
        color: Theme.palette.subtext
    }
}
