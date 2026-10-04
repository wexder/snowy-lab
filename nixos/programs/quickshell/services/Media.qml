pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

// MPRIS. Sticks to whichever player is actually playing, falling back to the
// last one that was, so the bar widget does not flicker between players.
Singleton {
    id: root

    readonly property list<MprisPlayer> players: [...Mpris.players.values].filter(p => p.canControl)

    property MprisPlayer active: null

    readonly property bool hasPlayer: !!active
    readonly property bool playing: active?.isPlaying ?? false
    readonly property string title: active?.trackTitle ?? ""
    readonly property string artist: active?.trackArtist ?? ""
    readonly property string album: active?.trackAlbum ?? ""
    readonly property string artUrl: active?.trackArtUrl ?? ""

    readonly property string label: !hasPlayer ? "" : artist ? `${artist} — ${title}` : title
    readonly property string icon: playing ? "󰏤" : "󰐊"

    // 0..1, or -1 when the player does not report a length.
    readonly property real progress: {
        if (!active?.lengthSupported || !active?.positionSupported || active.length <= 0)
            return -1;
        return Math.max(0, Math.min(1, active.position / active.length));
    }

    function _pick(): void {
        const candidates = root.players;
        if (candidates.length === 0) {
            root.active = null;
            return;
        }
        // Prefer an actively playing player; otherwise keep the current one.
        const playingNow = candidates.find(p => p.isPlaying);
        if (playingNow) {
            root.active = playingNow;
        } else if (!candidates.includes(root.active)) {
            root.active = candidates[0];
        }
    }

    function playPause(): void { root.active?.togglePlaying(); }
    function next(): void { root.active?.next(); }
    function previous(): void { root.active?.previous(); }

    onPlayersChanged: _pick()

    Instantiator {
        model: root.players
        delegate: Connections {
            required property MprisPlayer modelData
            target: modelData
            function onIsPlayingChanged(): void {
                root._pick();
            }
        }
    }

    // MPRIS position is not push-based; poll only while something is playing
    // and a consumer is showing progress.
    property int subscribers: 0
    Timer {
        running: root.playing && root.subscribers > 0
        interval: 1000
        repeat: true
        onTriggered: root.active?.positionChanged()
    }
}
