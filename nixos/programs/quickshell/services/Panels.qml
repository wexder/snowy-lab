pragma Singleton

import Quickshell
import QtQuick

// Which overlay panels are open. Bar widgets and IPC both flip these flags, and
// the panels themselves are lazily loaded off them — nothing is instantiated
// until it is first opened.
Singleton {
    id: root

    property bool launcher: false
    property bool clipboard: false
    property bool controlCenter: false
    property bool notificationCenter: false
    property bool calendar: false

    readonly property list<string> names: ["launcher", "clipboard", "controlCenter", "notificationCenter", "calendar"]
    readonly property bool anyOpen: launcher || clipboard || controlCenter || notificationCenter || calendar

    // Only one panel is open at a time; opening one closes the rest.
    function open(name: string): void {
        for (const other of root.names)
            root[other] = other === name;
    }

    function close(name: string): void {
        root[name] = false;
    }

    function toggle(name: string): void {
        if (root[name])
            root.close(name);
        else
            root.open(name);
    }

    function closeAll(): void {
        for (const name of root.names)
            root[name] = false;
    }
}
