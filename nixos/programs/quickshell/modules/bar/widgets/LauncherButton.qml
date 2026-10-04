import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services

BarBlock {
    id: root

    tooltipText: "Applications"
    active: Panels.launcher
    onClicked: Panels.toggle("launcher")

    Icon {
        text: "󱄅"
        sizeMultiplier: 1.15
        color: Panels.launcher ? Theme.palette.accent : Theme.palette.text
    }
}
