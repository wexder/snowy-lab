pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// CPU/memory/swap read straight from /proc instead of spawning
// `free | grep | awk` on a timer.
Singleton {
    id: root

    // 0..1
    readonly property real cpuUsage: _cpuUsage
    readonly property real memoryUsage: memTotal > 0 ? (memTotal - memAvailable) / memTotal : 0
    readonly property real swapUsage: swapTotal > 0 ? (swapTotal - swapFree) / swapTotal : 0

    // kibibytes
    property int memTotal: 0
    property int memAvailable: 0
    property int swapTotal: 0
    property int swapFree: 0

    readonly property string memoryUsedText: _humanize(memTotal - memAvailable)
    readonly property string memoryTotalText: _humanize(memTotal)

    // Widgets bump this while they are visible; polling stops at zero.
    property int subscribers: 0

    property real _cpuUsage: 0
    property int _lastIdle: 0
    property int _lastTotal: 0

    function _humanize(kib: int): string {
        const gib = kib / 1048576;
        return gib >= 1 ? `${gib.toFixed(1)}G` : `${Math.round(kib / 1024)}M`;
    }

    function _parseMeminfo(text: string): void {
        for (const line of text.split("\n")) {
            const [key, value] = line.split(":");
            if (!value)
                continue;
            const kib = parseInt(value.trim());
            switch (key) {
            case "MemTotal": root.memTotal = kib; break;
            case "MemAvailable": root.memAvailable = kib; break;
            case "SwapTotal": root.swapTotal = kib; break;
            case "SwapFree": root.swapFree = kib; break;
            }
        }
    }

    function _parseStat(text: string): void {
        const fields = text.split("\n")[0].split(/\s+/).slice(1).map(n => parseInt(n) || 0);
        if (fields.length < 5)
            return;

        const idle = fields[3] + fields[4];
        const total = fields.reduce((a, b) => a + b, 0);
        const idleDelta = idle - root._lastIdle;
        const totalDelta = total - root._lastTotal;

        if (root._lastTotal > 0 && totalDelta > 0)
            root._cpuUsage = Math.max(0, Math.min(1, 1 - idleDelta / totalDelta));

        root._lastIdle = idle;
        root._lastTotal = total;
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: root._parseMeminfo(text())
    }

    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: root._parseStat(text())
    }

    Timer {
        running: root.subscribers > 0
        interval: 3000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            meminfo.reload();
            stat.reload();
        }
    }
}
