pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Runtime configuration.
//
// Values are generated declaratively by nix into config/generated.json (see
// nixos/programs/quickshell.nix). Every token is a binding onto that data with
// the nix default repeated as a fallback, so the config also runs standalone
// (`qs -p .`) and picks up edits to the json without a restart.
Singleton {
    id: root

    readonly property Colors colors: Colors {}
    readonly property Font font: Font {}
    readonly property Bar bar: Bar {}
    readonly property Behaviour behaviour: Behaviour {}

    // Parsed generated.json, or an empty object when it is missing or invalid.
    readonly property var data: {
        // Referenced so the bindings re-evaluate when the file is reloaded.
        file.fileChangeCount;
        try {
            return JSON.parse(file.text()) ?? ({});
        } catch (e) {
            return ({});
        }
    }

    FileView {
        id: file

        // Bumped on every reload to invalidate the bindings above.
        property int fileChangeCount: 0

        path: `${Quickshell.shellDir}/config/generated.json`
        // Read synchronously: an async read means the shell paints its first
        // frame in the fallback palette before the real one lands.
        blockLoading: true
        watchChanges: true

        onFileChanged: {
            reload();
            fileChangeCount++;
        }

        onLoadFailed: err => {
            if (err !== FileViewError.FileNotFound)
                console.warn("Config: could not read generated.json:", err);
        }
    }

    component Colors: QtObject {
        readonly property var _: root.data.colors ?? ({})

        // Neutrals — warm charcoal, faintly red-tinted so the accent reads as
        // part of the palette rather than pasted on top of a cool grey.
        readonly property color base: _.base ?? "#191316"
        readonly property color mantle: _.mantle ?? "#130E11"
        readonly property color surface: _.surface ?? "#241C20"
        readonly property color surfaceAlt: _.surfaceAlt ?? "#33272C"
        readonly property color overlay: _.overlay ?? "#4C3B42"

        // Foreground
        readonly property color text: _.text ?? "#F3E9EB"
        readonly property color subtext: _.subtext ?? "#DCCBCF"
        readonly property color muted: _.muted ?? "#9C858C"

        // Brand
        readonly property color primary: _.primary ?? "#C2354A"
        readonly property color secondary: _.secondary ?? "#E8697A"
        // Foreground for anything drawn on top of `primary`. Kept separate
        // because whether that needs to be light or dark depends entirely on
        // the palette — deriving it from `base` only works for light accents.
        readonly property color onPrimary: _.onPrimary ?? "#FFF1F3"

        // Semantic. `error` is deliberately a brighter, warmer red than
        // `primary` so an alert still reads as an alert next to brand colour.
        readonly property color success: _.success ?? "#6FAF7A"
        readonly property color warning: _.warning ?? "#E9A13B"
        readonly property color error: _.error ?? "#FF6B5B"
    }

    component Font: QtObject {
        readonly property var _: root.data.font ?? ({})

        readonly property string family: _.family ?? "FiraCode Nerd Font"
        readonly property string mono: _.mono ?? "FiraCode Nerd Font Mono"
        readonly property string symbols: _.symbols ?? "Symbols Nerd Font Mono"
        readonly property int size: _.size ?? 12
    }

    component Bar: QtObject {
        readonly property var _: root.data.bar ?? ({})

        readonly property int height: _.height ?? 34
        readonly property bool onTop: _.onTop ?? true
        readonly property real opacity: _.opacity ?? 0.85
        // Tray items to hide, matched on their id.
        readonly property var trayBlacklist: _.trayBlacklist ?? []
    }

    component Behaviour: QtObject {
        readonly property var _: root.data.behaviour ?? ({})

        // How long a popup stays on screen, in milliseconds.
        readonly property int notificationTimeout: _.notificationTimeout ?? 5000
        // Use notificationTimeout regardless of what the sending app asks for.
        readonly property bool ignoreAppTimeout: _.ignoreAppTimeout ?? true
        // Ceiling applied when app timeouts are honoured.
        readonly property int maxNotificationTimeout: _.maxNotificationTimeout ?? 15000
        // Keep prompts on screen until answered: notifications that both
        // carry answerable actions and asked for no expiry (timeout 0).
        readonly property bool persistActionable: _.persistActionable ?? true
        // How many notification popups may be on screen at once.
        readonly property int maxPopups: _.maxPopups ?? 4
        readonly property int osdTimeout: _.osdTimeout ?? 1500
        readonly property string terminal: _.terminal ?? "ghostty"
        readonly property string audioMixer: _.audioMixer ?? "pavucontrol"
        readonly property string networkEditor: _.networkEditor ?? "nm-connection-editor"
        readonly property string bluetoothManager: _.bluetoothManager ?? "blueman-manager"
    }
}
