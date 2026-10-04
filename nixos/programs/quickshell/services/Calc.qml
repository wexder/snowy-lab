pragma Singleton

import Quickshell
import QtQuick

// Inline calculator for the launcher. Deliberately not eval(): only arithmetic
// on a whitelisted grammar is accepted, so a stray query can never run code.
Singleton {
    id: root

    readonly property var _allowed: /^[0-9+\-*/%^().,\s]+$/

    function isExpression(query: string): bool {
        const trimmed = query.trim();
        if (trimmed.length < 3)
            return false;
        if (!_allowed.test(trimmed))
            return false;
        // Needs at least one operator, otherwise "42" would look like maths.
        return /[+\-*/%^]/.test(trimmed);
    }

    // Returns the formatted result, or "" when the expression is incomplete.
    function evaluate(query: string): string {
        const expression = query.trim().replace(/,/g, "").replace(/\^/g, "**");
        if (!_allowed.test(query.trim()))
            return "";
        try {
            const result = Function(`"use strict"; return (${expression});`)();
            if (typeof result !== "number" || !isFinite(result))
                return "";
            return Number.isInteger(result) ? String(result) : result.toFixed(6).replace(/\.?0+$/, "");
        } catch (e) {
            return "";
        }
    }
}
