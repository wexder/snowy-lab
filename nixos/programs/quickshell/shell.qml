//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import qs.config
import qs.services
import qs.modules.bar
import qs.modules.osd
import qs.modules.launcher
import qs.modules.clipboard
import qs.modules.controlcenter
import qs.modules.notifications

ShellRoot {
    id: root

    // Always present.
    Bar {}
    Osd {}
    NotificationPopups {}

    // Panels are only constructed the first time they are opened.
    LazyLoader {
        activeAsync: Panels.launcher
        Launcher {}
    }

    LazyLoader {
        activeAsync: Panels.clipboard
        ClipboardPanel {}
    }

    LazyLoader {
        activeAsync: Panels.controlCenter
        ControlCenter {}
    }

    LazyLoader {
        activeAsync: Panels.notificationCenter
        NotificationCenter {}
    }

    LazyLoader {
        activeAsync: Panels.calendar
        CalendarPanel {}
    }

    // ── IPC ──
    // Drive the shell from Hyprland keybinds:
    //   qs ipc call panels toggle launcher
    //   qs ipc call audio raise
    IpcHandler {
        target: "panels"

        function toggle(name: string): void {
            Panels.toggle(name);
        }

        function open(name: string): void {
            Panels.open(name);
        }

        function close(): void {
            Panels.closeAll();
        }
    }

    IpcHandler {
        target: "audio"

        function raise(): void {
            Audio.addVolume(0.05);
        }

        function lower(): void {
            Audio.addVolume(-0.05);
        }

        function mute(): void {
            Audio.toggleMute();
        }

        function micMute(): void {
            Audio.toggleMicMute();
        }
    }

    IpcHandler {
        target: "brightness"

        function raise(): void {
            Brightness.addValue(0.05);
        }

        function lower(): void {
            Brightness.addValue(-0.05);
        }
    }

    IpcHandler {
        target: "notifications"

        function clear(): void {
            Notifs.clear();
        }

        function dnd(): void {
            Notifs.toggleDnd();
        }
    }

    // Global shortcuts registered with the compositor, so the same actions work
    // without shelling out to `qs ipc`.
    GlobalShortcut {
        name: "launcher"
        description: "Toggle the application launcher"
        onPressed: Panels.toggle("launcher")
    }

    GlobalShortcut {
        name: "clipboard"
        description: "Toggle clipboard history"
        onPressed: Panels.toggle("clipboard")
    }

    GlobalShortcut {
        name: "controlCenter"
        description: "Toggle the control centre"
        onPressed: Panels.toggle("controlCenter")
    }

    GlobalShortcut {
        name: "notificationCenter"
        description: "Toggle the notification centre"
        onPressed: Panels.toggle("notificationCenter")
    }
}
