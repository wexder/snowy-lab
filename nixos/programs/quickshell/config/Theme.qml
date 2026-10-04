pragma Singleton

import Quickshell
import QtQuick
import qs.config

// Semantic design tokens. Widgets read from here, never from Config directly,
// so a palette swap never means touching a widget.
Singleton {
    id: root

    readonly property Palette palette: Palette {}
    readonly property Typography font: Typography {}
    readonly property Spacing spacing: Spacing {}
    readonly property Radius radius: Radius {}
    readonly property Duration duration: Duration {}

    readonly property int barHeight: Config.bar.height

    // Top/bottom inset for overlay surfaces. Overlay layers ignore the bar's
    // exclusive zone, so anything anchored to a screen edge has to step around
    // the bar itself — on whichever edge the bar currently lives.
    readonly property int barInsetTop: Config.bar.onTop ? barHeight : 0
    readonly property int barInsetBottom: Config.bar.onTop ? 0 : barHeight

    component Palette: QtObject {
        readonly property color background: Qt.alpha(Config.colors.base, Config.bar.opacity)
        readonly property color backgroundSolid: Config.colors.base
        readonly property color surface: Config.colors.surface
        readonly property color surfaceAlt: Config.colors.surfaceAlt
        readonly property color elevated: Config.colors.mantle
        readonly property color border: Config.colors.overlay
        readonly property color hover: Qt.alpha(Config.colors.overlay, 0.55)
        readonly property color pressed: Qt.alpha(Config.colors.overlay, 0.8)

        readonly property color text: Config.colors.text
        readonly property color subtext: Config.colors.subtext
        readonly property color muted: Config.colors.muted
        readonly property color onAccent: Config.colors.onPrimary

        readonly property color accent: Config.colors.primary
        readonly property color accentAlt: Config.colors.secondary
        readonly property color success: Config.colors.success
        readonly property color warning: Config.colors.warning
        readonly property color error: Config.colors.error
        readonly property color urgent: Config.colors.error

        readonly property color shadow: Qt.rgba(0, 0, 0, 0.45)
        readonly property color scrim: Qt.rgba(0, 0, 0, 0.35)
    }

    component Typography: QtObject {
        readonly property string family: Config.font.family
        readonly property string mono: Config.font.mono
        readonly property string symbols: Config.font.symbols

        readonly property int tiny: Config.font.size - 3
        readonly property int small: Config.font.size - 2
        readonly property int normal: Config.font.size
        readonly property int large: Config.font.size + 2
        readonly property int title: Config.font.size + 5
        readonly property int icon: Math.round(Config.font.size * 1.35)
        readonly property int iconLarge: Math.round(Config.font.size * 1.9)
    }

    component Spacing: QtObject {
        readonly property int none: 0
        readonly property int tiny: 2
        readonly property int small: 4
        readonly property int normal: 8
        readonly property int large: 12
        readonly property int huge: 18
        readonly property int giant: 26
    }

    component Radius: QtObject {
        readonly property int none: 0
        readonly property int small: 4
        readonly property int normal: 8
        readonly property int large: 14
        readonly property int full: 9999
    }

    component Duration: QtObject {
        readonly property int instant: 80
        readonly property int fast: 150
        readonly property int normal: 250
        readonly property int slow: 400

        readonly property int emphasized: 8
        readonly property int standard: 4
    }
}
