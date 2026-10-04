pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Clipboard history, backed by cliphist (started by services.cliphist in
// nixos/programs/desktop.nix). This replaces the
// `cliphist list | wofi -dmenu | cliphist decode | wl-copy` pipeline, so the
// same three steps live here: list, decode, copy.
Singleton {
    id: root

    // Newest first, as cliphist lists them. Each entry is
    // { id, preview, binary }.
    property var entries: []
    property bool loading: false

    // Read on demand rather than polled: the history only matters while the
    // panel is open.
    function refresh(): void {
        root.loading = true;
        listProc.running = true;
    }

    function search(query: string): var {
        const trimmed = query.trim().toLowerCase();
        if (!trimmed)
            return root.entries;
        return root.entries.filter(entry => entry.preview.toLowerCase().includes(trimmed));
    }

    // cliphist stores the payload out of line, so the entry has to be decoded
    // before it can go back on the clipboard. Passed as an argument rather
    // than interpolated into the script.
    function copy(entry: var): void {
        if (!entry)
            return;
        copyProc.command = ["sh", "-c", 'cliphist decode "$1" | wl-copy', "_", String(entry.id)];
        copyProc.running = true;
    }

    Process {
        id: listProc

        command: ["cliphist", "list"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = [];
                for (const line of text.split("\n")) {
                    if (!line)
                        continue;
                    // "<id>\t<single-line preview>"
                    const tab = line.indexOf("\t");
                    if (tab === -1)
                        continue;
                    const preview = line.slice(tab + 1);
                    parsed.push({
                        id: line.slice(0, tab),
                        preview: preview,
                        // cliphist renders images as "[[ binary data 25 KiB png 588x781 ]]".
                        binary: preview.startsWith("[[ binary data")
                    });
                }
                root.entries = parsed;
                root.loading = false;
            }
        }
    }

    Process {
        id: copyProc
    }
}
