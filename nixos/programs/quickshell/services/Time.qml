pragma Singleton

import Quickshell
import QtQuick

// Single clock for the whole shell. Replaces per-widget `date` subprocesses.
Singleton {
    id: root

    readonly property date now: clock.date

    readonly property string time: Qt.formatDateTime(now, "HH:mm")
    readonly property string timeWithSeconds: Qt.formatDateTime(now, "HH:mm:ss")
    readonly property string date: Qt.formatDateTime(now, "ddd d MMM")
    readonly property string dateLong: Qt.formatDateTime(now, "dddd, d MMMM yyyy")

    function format(fmt: string): string {
        return Qt.formatDateTime(now, fmt);
    }

    // Human readable duration, used for battery estimates and notification ages.
    function relative(seconds: int): string {
        if (seconds < 60)
            return "now";
        const mins = Math.floor(seconds / 60);
        if (mins < 60)
            return `${mins}m`;
        const hours = Math.floor(mins / 60);
        if (hours < 24)
            return `${hours}h ${mins % 60}m`;
        return `${Math.floor(hours / 24)}d`;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
