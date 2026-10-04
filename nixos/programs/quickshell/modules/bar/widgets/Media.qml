import QtQuick
import QtQuick.Layouts
import qs.modules.bar
import qs.components
import qs.config
import qs.services as Services

// Compact now-playing readout. Click toggles playback, scroll skips tracks.
BarBlock {
    id: root

    property int maxTextWidth: 220

    visible: Services.Media.hasPlayer && Services.Media.label !== ""
    tooltipText: Services.Media.hasPlayer ? `${Services.Media.title}\n${Services.Media.artist}` : ""

    onClicked: event => {
        if (event.button === Qt.RightButton)
            Services.Media.next();
        else if (event.button === Qt.MiddleButton)
            Services.Media.previous();
        else
            Services.Media.playPause();
    }

    Icon {
        text: Services.Media.icon
        sizeMultiplier: 0.85
        color: Services.Media.playing ? Theme.palette.accent : Theme.palette.muted
    }

    StyledText {
        text: Services.Media.label
        font.pointSize: Theme.font.small
        color: Theme.palette.subtext
        elide: Text.ElideRight
        maximumLineCount: 1
        Layout.maximumWidth: root.maxTextWidth
    }
}
