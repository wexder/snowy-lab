pragma Singleton

import Quickshell
import qs.config
import QtQuick

// Transient on-screen display for volume, mic and brightness. Shows itself when
// a value changes — including from a media key handled by the compositor — so
// keybinds need no extra wiring.
Singleton {
    id: root

    // "" | "volume" | "mic" | "brightness"
    property string kind: ""
    readonly property bool shown: kind !== ""

    // Suppresses the OSD during startup, when services emit their initial values.
    property bool armed: false

    function show(what: string): void {
        if (!root.armed)
            return;
        root.kind = what;
        hideTimer.restart();
    }

    function hide(): void {
        root.kind = "";
        hideTimer.stop();
    }

    Timer {
        id: hideTimer
        interval: Config.behaviour.osdTimeout
        onTriggered: root.hide()
    }

    Timer {
        running: true
        interval: 1500
        onTriggered: root.armed = true
    }

    Connections {
        target: Audio
        function onChanged(): void {
            root.show("volume");
        }
    }

    Connections {
        target: Brightness
        function onChanged(): void {
            root.show("brightness");
        }
    }
}
