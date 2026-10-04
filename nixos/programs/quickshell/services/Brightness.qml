pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Backlight control via brightnessctl. There is no native quickshell backlight
// service, but reads come from sysfs rather than shelling out on a timer.
Singleton {
    id: root

    signal changed

    readonly property bool available: max > 0
    property int max: 0
    property int current: 0

    readonly property real value: max > 0 ? current / max : 0
    readonly property int percent: Math.round(value * 100)

    readonly property string icon: {
        if (percent < 34)
            return "󰃞";
        if (percent < 67)
            return "󰃟";
        return "󰃠";
    }

    // The device is discovered once; the path is then read directly.
    property string device: ""

    function setValue(target: real): void {
        if (!root.available)
            return;
        const clamped = Math.max(0.01, Math.min(1, target));
        setProc.command = ["brightnessctl", "-d", root.device, "-m", "set", `${Math.round(clamped * 100)}%`];
        setProc.running = true;
        // Update optimistically so the OSD tracks the drag without waiting.
        root.current = Math.round(clamped * root.max);
        root.changed();
    }

    function addValue(delta: real): void {
        setValue(root.value + delta);
    }

    Process {
        id: discoverProc
        running: true
        command: ["sh", "-c", "ls -1 /sys/class/backlight | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim();
                if (!name)
                    return;
                root.device = name;
                maxFile.path = `/sys/class/backlight/${name}/max_brightness`;
                actualFile.path = `/sys/class/backlight/${name}/brightness`;
            }
        }
    }

    Process {
        id: setProc
    }

    FileView {
        id: maxFile
        onLoaded: root.max = parseInt(text().trim()) || 0
    }

    FileView {
        id: actualFile
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            root.current = parseInt(text().trim()) || 0;
            root.changed();
        }
    }
}
