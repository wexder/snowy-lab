pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

// Active keyboard layout, for the bar's language indicator.
//
// Hyprland's `activelayout` event carries only a friendly name ("Czech"), but
// the device list also carries `active_layout_index` alongside the configured
// `layout` list ("us,cz") — so the xkb code comes straight from the compositor
// rather than from a lookup table of language names.
Singleton {
    id: root

    // xkb code of the active layout, e.g. "us".
    property string code: ""
    // The compositor's friendly name for it, e.g. "English (US)".
    property string name: ""
    // Every configured layout, in the order they cycle.
    property var layouts: []

    // Nothing worth indicating when there is only one layout to be in.
    readonly property bool available: layouts.length > 1
    readonly property string label: code.toUpperCase()

    // The keyboard whose layout is shown. Hyprland tracks a layout per device,
    // so follow the one that last changed — that is the keyboard whose key the
    // user actually pressed. Empty until then, which falls back to `main`.
    property string device: ""

    function refresh(): void {
        devicesProc.running = true;
    }

    function cycle(): void {
        if (!root.available)
            return;
        const target = root.device || "current";
        cycleProc.command = ["hyprctl", "switchxkblayout", target, "next"];
        cycleProc.running = true;
    }

    Process {
        id: devicesProc

        running: true
        command: ["hyprctl", "-j", "devices"]

        stdout: StdioCollector {
            onStreamFinished: {
                let keyboards;
                try {
                    keyboards = JSON.parse(text).keyboards ?? [];
                } catch (e) {
                    console.warn("Keyboard: could not parse hyprctl devices:", e);
                    return;
                }

                const keyboard = keyboards.find(k => k.name === root.device) ?? keyboards.find(k => k.main) ?? keyboards[0];
                if (!keyboard)
                    return;

                const codes = (keyboard.layout ?? "").split(",").map(entry => entry.trim()).filter(entry => entry);
                root.layouts = codes;
                root.code = codes[keyboard.active_layout_index] ?? codes[0] ?? "";
                root.name = keyboard.active_keymap ?? "";
            }
        }
    }

    Process {
        id: cycleProc
        onExited: root.refresh()
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name !== "activelayout")
                return;
            // "DEVICE,LAYOUT NAME" — split once, since a layout name may itself
            // contain a comma.
            const comma = event.data.indexOf(",");
            root.device = comma === -1 ? event.data : event.data.slice(0, comma);
            root.refresh();
        }
    }
}
