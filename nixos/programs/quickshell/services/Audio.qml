pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

// Pipewire wrapper. Volume changes emit `changed` so the OSD can react to
// keybinds without every widget growing its own signal wiring.
Singleton {
    id: root

    signal changed

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? true
    readonly property int volumePercent: Math.round(volume * 100)

    readonly property real micVolume: source?.audio?.volume ?? 0
    readonly property bool micMuted: source?.audio?.muted ?? true

    readonly property list<PwNode> sinks: [...Pipewire.nodes.values].filter(n => n.isSink && n.audio)
    readonly property list<PwNode> sources: [...Pipewire.nodes.values].filter(n => !n.isSink && n.audio && !n.isStream)

    readonly property string icon: {
        if (muted || volume === 0)
            return "󰖁";
        if (volume < 0.34)
            return "󰕿";
        if (volume < 0.67)
            return "󰖀";
        return "󰕾";
    }

    function setVolume(value: real): void {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(1, value));
    }

    function addVolume(delta: real): void {
        setVolume(root.volume + delta);
    }

    function toggleMute(): void {
        if (sink?.audio)
            sink.audio.muted = !sink.audio.muted;
    }

    function toggleMicMute(): void {
        if (source?.audio)
            source.audio.muted = !source.audio.muted;
    }

    function setDefaultSink(node: PwNode): void {
        Pipewire.preferredDefaultAudioSink = node;
    }

    // Keeps the default nodes bound so their audio properties stay live.
    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    onVolumeChanged: root.changed()
    onMutedChanged: root.changed()
}
