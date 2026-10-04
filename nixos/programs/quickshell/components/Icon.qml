import QtQuick
import qs.config

// Nerd Font glyph. Kept separate from StyledText because symbols need their own
// family and optical size — the old config did this by wrapping every character
// in rich text and re-parsing it on each update.
Text {
    property real sizeMultiplier: 1

    color: Theme.palette.text
    font.family: Theme.font.symbols
    font.pointSize: Math.round(Theme.font.icon * sizeMultiplier)
    renderType: Text.NativeRendering
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Behavior on color {
        ColorAnimation {
            duration: Theme.duration.fast
        }
    }
}
