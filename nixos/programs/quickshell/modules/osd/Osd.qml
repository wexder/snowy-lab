import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.config
import qs.services as Services

// Volume / brightness OSD, shown on the focused monitor only.
PanelWindow {
    id: root

    readonly property real value: {
        switch (Services.Osd.kind) {
        case "brightness": return Services.Brightness.value;
        case "mic": return Services.Audio.micVolume;
        default: return Services.Audio.volume;
        }
    }

    readonly property string icon: {
        switch (Services.Osd.kind) {
        case "brightness": return Services.Brightness.icon;
        case "mic": return Services.Audio.micMuted ? "󰍭" : "󰍬";
        default: return Services.Audio.icon;
        }
    }

    readonly property bool muted: Services.Osd.kind === "volume" ? Services.Audio.muted : Services.Osd.kind === "mic" ? Services.Audio.micMuted : false

    screen: Services.Hypr.focusedScreen
    visible: reveal > 0
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:osd"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    implicitWidth: 260
    implicitHeight: 64

    anchors.bottom: true
    margins.bottom: 120

    // Click-through.
    mask: Region {}

    property real reveal: Services.Osd.shown ? 1 : 0

    Behavior on reveal {
        NumberAnimation {
            duration: Theme.duration.normal
            easing.type: Easing.OutCubic
        }
    }

    StyledRect {
        anchors.fill: parent
        color: Theme.palette.backgroundSolid
        radius: Theme.radius.large
        border.width: 1
        border.color: Theme.palette.border

        opacity: root.reveal
        scale: 0.9 + root.reveal * 0.1

        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing.large
            spacing: Theme.spacing.large

            Icon {
                text: root.icon
                sizeMultiplier: 1.4
                color: root.muted ? Theme.palette.muted : Theme.palette.accent
                Layout.preferredWidth: Theme.font.iconLarge
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.small

                StyledText {
                    text: `${Math.round(root.value * 100)}%`
                    font.pointSize: Theme.font.small
                    color: Theme.palette.subtext
                }

                StyledRect {
                    Layout.fillWidth: true
                    implicitHeight: 6
                    radius: Theme.radius.full
                    color: Theme.palette.surfaceAlt

                    StyledRect {
                        width: parent.width * Math.max(0, Math.min(1, root.value))
                        height: parent.height
                        radius: parent.radius
                        color: root.muted ? Theme.palette.muted : Theme.palette.accent

                        Behavior on width {
                            NumberAnimation {
                                duration: Theme.duration.fast
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }
}
