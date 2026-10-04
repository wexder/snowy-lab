import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services as Services

BarBlock {
    id: root

    signal requestControlCenter

    visible: Services.Bt.available
    tooltipText: `Bluetooth — ${Services.Bt.label}`

    onClicked: root.requestControlCenter()

    Icon {
        text: Services.Bt.icon
        color: Services.Bt.connected.length > 0 ? Theme.palette.accent : Services.Bt.enabled ? Theme.palette.text : Theme.palette.muted
    }
}
