pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import qs.config
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

    // Watts flowing out of (or into) the battery right now.
    readonly property real rate: Math.abs(device?.changeRate ?? 0)
    // Seconds a full charge would last at the current draw; 0 unless discharging.
    readonly property int fullRuntime: onBattery && rate > 0.1 ? Math.round((device?.energyCapacity ?? 0) / rate * 3600) : 0

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

    // ── Charge limit ──
    // Stops charging at the firmware's long-life level (about 80% on Lenovo) to
    // slow battery wear. Quickshell's UPower module does not expose this, so it
    // goes over D-Bus directly; UPower authorises the active session and
    // remembers the setting across reboots.
    readonly property string batteryPath: {
        const battery = UPower.devices.values.find(dev => dev.isLaptopBattery && dev.nativePath);
        return battery ? `/org/freedesktop/UPower/devices/battery_${battery.nativePath}` : "";
    }
    property bool chargeLimitSupported: false
    property bool chargeLimit: false

    function setChargeLimit(enabled: bool): void {
        if (!root.chargeLimitSupported)
            return;
        limitSet.command = ["busctl", "--system", "call", "org.freedesktop.UPower", root.batteryPath, "org.freedesktop.UPower.Device", "EnableChargeThreshold", "b", enabled ? "true" : "false"];
        limitSet.running = true;
    }

    // The command is assembled at call time: binding it to batteryPath lets the
    // process start before the binding has caught up, with an empty path.
    function refreshChargeLimit(): void {
        if (root.batteryPath === "")
            return;
        limitGet.command = ["busctl", "--system", "get-property", "org.freedesktop.UPower", root.batteryPath, "org.freedesktop.UPower.Device", "ChargeThresholdSupported", "ChargeThresholdEnabled"];
        limitGet.running = true;
    }

    onBatteryPathChanged: refreshChargeLimit()
    Component.onCompleted: refreshChargeLimit()

    Process {
        id: limitGet
        stdout: StdioCollector {
            onStreamFinished: {
                // One "b true" / "b false" line per property, in order.
                const values = text.trim().split("\n").map(line => line.trim() === "b true");
                root.chargeLimitSupported = values[0] ?? false;
                root.chargeLimit = values[1] ?? false;
            }
        }
    }

    Process {
        id: limitSet
        // Re-read rather than assume: the call can be refused.
        onExited: root.refreshChargeLimit()
    }

    // Unplugging trades refresh rate and backlight for runtime; plugging back in
    // restores the refresh rate but leaves the backlight where it was put. The
    // backlight is only ever lowered, never raised to the battery level.
    onOnBatteryChanged: {
        Hypr.setOnBattery(root.onBattery, Config.behaviour.batteryRefreshRate);

        const brightness = Config.behaviour.batteryBrightness;
        if (root.onBattery && brightness > 0 && Brightness.value > brightness)
            Brightness.setValue(brightness);
    }
}
