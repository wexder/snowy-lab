pragma Singleton

import Quickshell
import Quickshell.Networking
import QtQuick

// Native NetworkManager bindings — no nmcli parsing.
Singleton {
    id: root

    readonly property list<NetworkDevice> devices: [...Networking.devices.values]

    // A machine can have several devices of a type (a dock's USB ethernet
    // alongside the built-in port), so prefer whichever one is actually up.
    function _pickDevice(type: int): var {
        const matching = root.devices.filter(device => device.type === type);
        return matching.find(device => device.connected) ?? matching[0] ?? null;
    }

    readonly property WifiDevice wifi: _pickDevice(DeviceType.Wifi)
    readonly property WiredDevice ethernet: _pickDevice(DeviceType.Wired)

    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property bool ethernetConnected: ethernet?.connected ?? false

    // NetworkManager reports Limited rather than Full whenever its connectivity
    // check cannot reach the test endpoint, which is common on networks that
    // block it — so trust the device state and only treat an explicit "None"
    // as offline.
    readonly property bool online: (ethernetConnected || !!activeWifi) && Networking.connectivity !== NetworkConnectivity.None

    readonly property Network activeWifi: wifi ? [...wifi.networks.values].find(n => n.connected) ?? null : null
    readonly property string ssid: activeWifi?.name ?? ""
    readonly property int signalStrength: activeWifi?.signalStrength ?? 0

    // Strongest entry per SSID, connected first, then by signal.
    readonly property list<Network> visibleNetworks: {
        if (!wifi)
            return [];
        const best = new Map();
        for (const network of wifi.networks.values) {
            if (!network.name)
                continue;
            const existing = best.get(network.name);
            if (!existing || (network.signalStrength ?? 0) > (existing.signalStrength ?? 0))
                best.set(network.name, network);
        }
        return [...best.values()].sort((a, b) => {
            if (a.connected !== b.connected)
                return a.connected ? -1 : 1;
            if (a.known !== b.known)
                return a.known ? -1 : 1;
            return (b.signalStrength ?? 0) - (a.signalStrength ?? 0);
        });
    }

    readonly property string icon: {
        if (ethernetConnected)
            return "󰈀";
        if (!wifiEnabled)
            return "󰤮";
        if (!activeWifi)
            return "󰤯";
        const bars = ["󰤟", "󰤢", "󰤥", "󰤨"];
        return bars[Math.min(3, Math.floor(signalStrength / 26))];
    }

    readonly property string label: ethernetConnected ? "Wired" : activeWifi ? ssid : wifiEnabled ? "Disconnected" : "Wi-Fi off"

    function toggleWifi(): void {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    function rescan(): void {
        if (root.wifi)
            root.wifi.scannerEnabled = true;
    }
}
