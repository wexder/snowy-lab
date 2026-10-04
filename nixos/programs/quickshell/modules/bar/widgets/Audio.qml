import QtQuick
import Quickshell
import qs.modules.bar
import qs.components
import qs.config
import qs.services as Services

BarBlock {
    id: root

    signal requestOsd

    tooltipText: Services.Audio.muted ? "Muted — scroll to change, click to unmute" : `Volume ${Services.Audio.volumePercent}%`

    onClicked: event => {
        if (event.button === Qt.RightButton)
            Quickshell.execDetached([Config.behaviour.audioMixer]);
        else
            Services.Audio.toggleMute();
    }

    onWheel: event => {
        Services.Audio.addVolume(event.angleDelta.y > 0 ? 0.05 : -0.05);
        root.requestOsd();
    }

    Icon {
        text: Services.Audio.icon
        color: Services.Audio.muted ? Theme.palette.muted : Theme.palette.text
    }

    StyledText {
        text: `${Services.Audio.volumePercent}%`
        font.pointSize: Theme.font.small
        color: Services.Audio.muted ? Theme.palette.muted : Theme.palette.subtext
    }
}
