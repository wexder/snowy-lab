pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

// UPower instead of polling /sys/class/power_supply with `cat` every second.
Singleton {
    id: root

    readonly property UPowerDevice device: UPower.displayDevice
    readonly property bool available: device?.isLaptopBattery ?? false
    readonly property bool onBattery: UPower.onBattery

    readonly property real percentage: device?.percentage ?? 0
    readonly property int percent: Math.round(percentage * 100)
    readonly property bool charging: device?.state === UPowerDeviceState.Charging
    readonly property bool full: device?.state === UPowerDeviceState.FullyCharged
    readonly property bool low: available && !charging && percent <= 20
    readonly property bool critical: available && !charging && percent <= 10

    // Seconds; 0 when UPower has not worked out an estimate yet.
    readonly property int timeRemaining: charging ? (device?.timeToFull ?? 0) : (device?.timeToEmpty ?? 0)

    readonly property string icon: {
        if (charging)
            return "󰂄";
        if (!available)
            return "󰚥";
        const levels = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
        return levels[Math.min(9, Math.floor(percent / 10))];
    }

    // "critical" | "low" | "charging" | "normal" — widgets map this to a colour.
    readonly property string level: critical ? "critical" : low ? "low" : charging ? "charging" : "normal"

    readonly property bool hasProfiles: PowerProfiles.hasPerformanceProfile
    readonly property int profile: PowerProfiles.profile

    function setProfile(value: int): void {
        PowerProfiles.profile = value;
    }
}
