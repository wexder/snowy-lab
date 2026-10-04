pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import QtQuick

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool available: !!adapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property bool discovering: adapter?.discovering ?? false

    readonly property list<BluetoothDevice> devices: adapter ? [...adapter.devices.values] : []
    readonly property list<BluetoothDevice> connected: devices.filter(d => d.connected)

    // Connected first, then paired, then whatever the scan turned up.
    readonly property list<BluetoothDevice> sorted: [...devices].sort((a, b) => {
        if (a.connected !== b.connected)
            return a.connected ? -1 : 1;
        if (a.paired !== b.paired)
            return a.paired ? -1 : 1;
        return (a.name ?? "").localeCompare(b.name ?? "");
    })

    readonly property string icon: !enabled ? "󰂲" : connected.length > 0 ? "󰂱" : "󰂯"
    readonly property string label: !available ? "No adapter" : !enabled ? "Off" : connected.length > 0 ? connected[0].name : "On"

    function toggle(): void {
        if (adapter)
            adapter.enabled = !adapter.enabled;
    }

    function toggleDiscovery(): void {
        if (adapter)
            adapter.discovering = !adapter.discovering;
    }

    function iconFor(device: BluetoothDevice): string {
        const name = device?.icon ?? "";
        if (name.includes("headset") || name.includes("headphone"))
            return "󰋋";
        if (name.includes("audio"))
            return "󰓃";
        if (name.includes("mouse"))
            return "󰦋";
        if (name.includes("keyboard"))
            return "󰌌";
        if (name.includes("phone"))
            return "󰄜";
        return "󰂯";
    }
}
