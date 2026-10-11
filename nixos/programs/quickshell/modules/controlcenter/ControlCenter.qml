import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.UPower
import qs.components
import qs.config
import qs.services as Services

OverlayPanel {
    id: root

    shown: Services.Panels.controlCenter
    onDismissed: {
        Services.Panels.close("controlCenter");
        expandedSection = "";
    }

    placement: "topRight"
    panelWidth: 400
    panelHeight: Math.min(720, content.implicitHeight + Theme.spacing.large * 2)

    // "" | "wifi" | "bluetooth"
    property string expandedSection: ""

    function toggleSection(name: string): void {
        root.expandedSection = root.expandedSection === name ? "" : name;
        if (name === "wifi" && root.expandedSection === "wifi")
            Services.Net.rescan();
        if (name === "bluetooth" && root.expandedSection === "bluetooth")
            Services.Bt.toggleDiscovery();
    }

    ColumnLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Theme.spacing.large
        spacing: Theme.spacing.normal

        // ── Header: battery status and session actions ──
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.normal

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                StyledText {
                    text: Services.Time.time
                    font.pointSize: Theme.font.title
                    font.bold: true
                }

                StyledText {
                    text: Services.Battery.available ? `${Services.Battery.icon}  ${Services.Battery.percent}%${Services.Battery.timeRemaining > 0 ? " · " + Services.Time.relative(Services.Battery.timeRemaining) : ""}` : Services.Time.dateLong
                    font.pointSize: Theme.font.tiny
                    color: Theme.palette.muted
                }
            }

            IconButton {
                icon: "󰌾"
                iconColor: Theme.palette.subtext
                onClicked: {
                    root.close();
                    Quickshell.execDetached(["hyprlock"]);
                }
            }

            IconButton {
                icon: "󰤄"
                iconColor: Theme.palette.subtext
                onClicked: {
                    root.close();
                    Quickshell.execDetached(["systemctl", "suspend"]);
                }
            }

            IconButton {
                icon: "󰐥"
                iconColor: Theme.palette.error
                onClicked: {
                    root.close();
                    Quickshell.execDetached(["systemctl", "poweroff"]);
                }
            }
        }

        // ── Quick toggles ──
        QuickToggle {
            icon: Services.Net.icon
            label: "Wi-Fi"
            sublabel: Services.Net.label
            active: Services.Net.wifiEnabled
            expandable: !!Services.Net.wifi
            expanded: root.expandedSection === "wifi"
            onToggled: Services.Net.toggleWifi()
            onExpandRequested: root.toggleSection("wifi")
        }

        DeviceList {
            expanded: root.expandedSection === "wifi"
            model: Services.Net.visibleNetworks

            rowDelegate: StyledRect {
                id: wifiRow

                required property var modelData

                width: ListView.view.width
                height: 40
                radius: Theme.radius.small
                color: wifiState.containsMouse ? Theme.palette.hover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.normal
                    anchors.rightMargin: Theme.spacing.normal
                    spacing: Theme.spacing.normal

                    Icon {
                        text: wifiRow.modelData.connected ? "󰸋" : "󰤨"
                        sizeMultiplier: 0.85
                        color: wifiRow.modelData.connected ? Theme.palette.accent : Theme.palette.subtext
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: wifiRow.modelData.name
                        font.pointSize: Theme.font.small
                        color: wifiRow.modelData.connected ? Theme.palette.text : Theme.palette.subtext
                    }

                    StyledText {
                        text: `${wifiRow.modelData.signalStrength ?? 0}%`
                        font.pointSize: Theme.font.tiny
                        color: Theme.palette.muted
                    }
                }

                StateLayer {
                    id: wifiState
                    radius: Theme.radius.small
                    hoverColor: "transparent"
                    pressColor: "transparent"
                    onClicked: {
                        const network = wifiRow.modelData;
                        if (network.connected)
                            network.disconnect();
                        else if (network.known)
                            network.connect();
                        else
                            // Unknown networks need a passphrase; hand off to
                            // the NM editor rather than reimplementing the
                            // secret-agent dialogs here.
                            Quickshell.execDetached([Config.behaviour.networkEditor]);
                    }
                }
            }
        }

        QuickToggle {
            icon: Services.Bt.icon
            label: "Bluetooth"
            sublabel: Services.Bt.label
            active: Services.Bt.enabled
            visible: Services.Bt.available
            expandable: Services.Bt.enabled
            expanded: root.expandedSection === "bluetooth"
            onToggled: Services.Bt.toggle()
            onExpandRequested: root.toggleSection("bluetooth")
        }

        DeviceList {
            expanded: root.expandedSection === "bluetooth"
            model: Services.Bt.sorted

            rowDelegate: StyledRect {
                id: btRow

                required property var modelData

                width: ListView.view.width
                height: 40
                radius: Theme.radius.small
                color: btState.containsMouse ? Theme.palette.hover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.normal
                    anchors.rightMargin: Theme.spacing.normal
                    spacing: Theme.spacing.normal

                    Icon {
                        text: Services.Bt.iconFor(btRow.modelData)
                        sizeMultiplier: 0.85
                        color: btRow.modelData.connected ? Theme.palette.accent : Theme.palette.subtext
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: btRow.modelData.name || btRow.modelData.address
                        font.pointSize: Theme.font.small
                        color: btRow.modelData.connected ? Theme.palette.text : Theme.palette.subtext
                    }

                    StyledText {
                        visible: btRow.modelData.batteryAvailable
                        text: `${Math.round((btRow.modelData.battery ?? 0) * 100)}%`
                        font.pointSize: Theme.font.tiny
                        color: Theme.palette.muted
                    }
                }

                StateLayer {
                    id: btState
                    radius: Theme.radius.small
                    hoverColor: "transparent"
                    pressColor: "transparent"
                    onClicked: {
                        const device = btRow.modelData;
                        device.connected = !device.connected;
                    }
                }
            }
        }

        QuickToggle {
            icon: Services.Notifs.doNotDisturb ? "󰂛" : "󰂚"
            label: "Do not disturb"
            sublabel: Services.Notifs.doNotDisturb ? "Popups suppressed" : `${Services.Notifs.count} in centre`
            active: Services.Notifs.doNotDisturb
            onToggled: Services.Notifs.toggleDnd()
        }

        // ── Sliders ──
        SliderRow {
            icon: Services.Audio.icon
            value: Services.Audio.volume
            dimmed: Services.Audio.muted
            onMoved: value => Services.Audio.setVolume(value)
            onIconClicked: Services.Audio.toggleMute()
        }

        SliderRow {
            icon: Services.Audio.micMuted ? "󰍭" : "󰍬"
            value: Services.Audio.micVolume
            dimmed: Services.Audio.micMuted
            visible: !!Services.Audio.source
            onMoved: value => {
                if (Services.Audio.source?.audio)
                    Services.Audio.source.audio.volume = value;
            }
            onIconClicked: Services.Audio.toggleMicMute()
        }

        SliderRow {
            icon: Services.Brightness.icon
            value: Services.Brightness.value
            visible: Services.Brightness.available
            onMoved: value => Services.Brightness.setValue(value)
        }

        MediaCard {}

        // ── Power profile ──
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: Theme.spacing.tiny
            visible: Services.Battery.hasProfiles
            spacing: Theme.spacing.small

            Repeater {
                model: [
                    { label: "Saver", icon: "󰌪", value: PowerProfile.PowerSaver },
                    { label: "Balanced", icon: "󰾅", value: PowerProfile.Balanced },
                    { label: "Performance", icon: "󰓅", value: PowerProfile.Performance }
                ]

                delegate: StyledRect {
                    id: profileButton

                    required property var modelData
                    readonly property bool selected: Services.Battery.profile === modelData.value

                    Layout.fillWidth: true
                    implicitHeight: 34
                    radius: Theme.radius.small
                    color: selected ? Theme.palette.accent : Theme.palette.surface

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacing.small

                        Icon {
                            text: profileButton.modelData.icon
                            sizeMultiplier: 0.8
                            color: profileButton.selected ? Theme.palette.onAccent : Theme.palette.subtext
                        }

                        StyledText {
                            text: profileButton.modelData.label
                            font.pointSize: Theme.font.tiny
                            color: profileButton.selected ? Theme.palette.onAccent : Theme.palette.subtext
                        }
                    }

                    StateLayer {
                        radius: Theme.radius.small
                        onClicked: Services.Battery.setProfile(profileButton.modelData.value)
                    }
                }
            }
        }

        // ── Charge limit ──
        StyledRect {
            id: chargeLimitButton

            readonly property bool active: Services.Battery.chargeLimit

            Layout.fillWidth: true
            visible: Services.Battery.chargeLimitSupported
            implicitHeight: 34
            radius: Theme.radius.small
            color: active ? Theme.palette.accent : Theme.palette.surface

            RowLayout {
                anchors.centerIn: parent
                spacing: Theme.spacing.small

                Icon {
                    text: "󰂏"
                    sizeMultiplier: 0.8
                    color: chargeLimitButton.active ? Theme.palette.onAccent : Theme.palette.subtext
                }

                StyledText {
                    text: chargeLimitButton.active ? "Charge limit on" : "Charge limit off"
                    font.pointSize: Theme.font.tiny
                    color: chargeLimitButton.active ? Theme.palette.onAccent : Theme.palette.subtext
                }
            }

            StateLayer {
                radius: Theme.radius.small
                onClicked: Services.Battery.setChargeLimit(!chargeLimitButton.active)
            }
        }
    }
}
