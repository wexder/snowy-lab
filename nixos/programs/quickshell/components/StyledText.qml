import QtQuick
import qs.config

Text {
    color: Theme.palette.text
    font.family: Theme.font.family
    font.pointSize: Theme.font.normal
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight

    Behavior on color {
        ColorAnimation {
            duration: Theme.duration.fast
        }
    }
}
