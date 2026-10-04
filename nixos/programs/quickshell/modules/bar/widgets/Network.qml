import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services as Services

BarBlock {
    id: root

    signal requestControlCenter

    tooltipText: Services.Net.ethernetConnected ? "Wired connection" : Services.Net.activeWifi ? `${Services.Net.ssid} — ${Services.Net.signalStrength}%` : Services.Net.label

    onClicked: root.requestControlCenter()

    Icon {
        text: Services.Net.icon
        color: Services.Net.online ? Theme.palette.text : Theme.palette.muted
    }
}
