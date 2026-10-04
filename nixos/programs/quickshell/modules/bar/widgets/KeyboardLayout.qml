import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services as Services

// Active keyboard layout. Hidden when only one layout is configured — layouts
// are excluded from the RowLayout while invisible, so it takes no space.
BarBlock {
    id: root

    visible: Services.Keyboard.available
    tooltipText: Services.Keyboard.name ? `${Services.Keyboard.name} — click to switch` : ""

    onClicked: Services.Keyboard.cycle()

    Icon {
        text: "󰌌"
        sizeMultiplier: 0.85
        color: Theme.palette.accentAlt
    }

    StyledText {
        text: Services.Keyboard.label
        font.pointSize: Theme.font.small
        color: Theme.palette.subtext
    }
}
