pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Launcher index. Uses DesktopEntries, which respects XDG_DATA_DIRS — the old
// launcher globbed /usr/share/applications, which is empty on NixOS.
Singleton {
    id: root

    readonly property list<DesktopEntry> all: [...DesktopEntries.applications.values]
        .filter(entry => !entry.noDisplay)
        .sort((a, b) => a.name.localeCompare(b.name))

    // Launch counts, so frequently used apps float to the top of an empty query.
    property var frecency: ({})

    function launch(entry: DesktopEntry): void {
        if (!entry)
            return;
        const counts = root.frecency;
        counts[entry.id] = (counts[entry.id] ?? 0) + 1;
        root.frecency = counts;
        frecencyFile.setText(JSON.stringify(counts));
        entry.execute();
    }

    function search(query: string): list<var> {
        const trimmed = query.trim();
        if (!trimmed) {
            return [...root.all]
                .sort((a, b) => (root.frecency[b.id] ?? 0) - (root.frecency[a.id] ?? 0))
                .slice(0, 40);
        }

        const scored = [];
        for (const entry of root.all) {
            const score = root.score(entry, trimmed);
            if (score > 0)
                scored.push({ entry, score });
        }
        return scored
            .sort((a, b) => b.score - a.score || a.entry.name.localeCompare(b.entry.name))
            .slice(0, 40)
            .map(hit => hit.entry);
    }

    // Normalises a DesktopEntry field to a lowercase string.
    //
    // `keywords` and `categories` come back as list objects rather than
    // strings, so calling toLowerCase() on them directly throws — which took
    // out the whole scoring pass and left the launcher unfiltered.
    function fieldText(value: var): string {
        if (value === undefined || value === null)
            return "";
        if (typeof value === "string")
            return value.toLowerCase();
        // List-valued fields are iterable but are not real JS arrays.
        try {
            return Array.from(value).join(" ").toLowerCase();
        } catch (e) {
            return String(value).toLowerCase();
        }
    }

    // Higher is better; 0 means no match.
    //
    // Only short, identity-like fields (name, id) are matched loosely. Running
    // a subsequence match over comment and categories makes almost every query
    // match almost every app — "steam" pulled in Discord, "gimp" ranked
    // Moonlight first.
    function score(entry: DesktopEntry, query: string): int {
        const q = query.toLowerCase();
        const fields = [
            { text: root.fieldText(entry.name), weight: 100, loose: true },
            { text: root.fieldText(entry.genericName), weight: 60, loose: false },
            { text: root.fieldText(entry.id), weight: 50, loose: true },
            { text: root.fieldText(entry.keywords), weight: 40, loose: false },
            { text: root.fieldText(entry.comment), weight: 15, loose: false },
            { text: root.fieldText(entry.categories), weight: 5, loose: false }
        ];

        let best = 0;
        for (const field of fields) {
            if (!field.text)
                continue;

            const index = field.text.indexOf(q);
            if (index === 0) {
                best = Math.max(best, field.weight * 4);
            } else if (index > 0) {
                // Matching the start of a word beats matching mid-word.
                const boundary = " -_.".includes(field.text[index - 1]);
                best = Math.max(best, field.weight * (boundary ? 3 : 2));
            } else if (field.loose && root.subsequence(field.text, q)) {
                best = Math.max(best, Math.round(field.weight / 2));
            }
        }

        // Small nudge from usage so ties resolve to what you actually launch.
        return best > 0 ? best + Math.min(20, root.frecency[entry.id] ?? 0) : 0;
    }

    // "gimp" matches "GNU Image Manipulation Program" style acronym typing.
    function subsequence(haystack: string, needle: string): bool {
        let index = 0;
        for (const char of haystack) {
            if (char === needle[index])
                index++;
            if (index === needle.length)
                return true;
        }
        return false;
    }

    FileView {
        id: frecencyFile
        path: `${Quickshell.stateDir}/launcher-frecency.json`
        onLoaded: {
            try {
                root.frecency = JSON.parse(text()) ?? {};
            } catch (e) {
                root.frecency = {};
            }
        }
        onLoadFailed: root.frecency = ({})
    }
}
