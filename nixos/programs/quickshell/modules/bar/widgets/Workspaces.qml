import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.components
import qs.config
import qs.services

// Persistent workspace pills for the monitor this bar is on. The active pill
// widens; occupied-but-inactive workspaces stay visible as dots.
Item {
    id: root

    required property ShellScreen screen
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    implicitWidth: pills.implicitWidth + Theme.spacing.normal * 2
    implicitHeight: Theme.barHeight
    Layout.preferredWidth: implicitWidth
    Layout.fillHeight: true

    StyledRect {
        anchors.fill: parent
        anchors.topMargin: Theme.spacing.small
        anchors.bottomMargin: Theme.spacing.small
        radius: Theme.radius.full
        color: Qt.alpha(Theme.palette.surface, 0.55)
    }

    RowLayout {
        id: pills
        anchors.centerIn: parent
        spacing: Theme.spacing.small

        Repeater {
            model: Hypr.workspaceCount

            delegate: Item {
                id: pill

                required property int index
                readonly property int wsId: index + 1
                readonly property HyprlandWorkspace workspace: Hypr.workspaceById(wsId)
                readonly property bool focused: root.monitor?.activeWorkspace?.id === wsId
                readonly property bool occupied: (workspace?.toplevels?.values?.length ?? 0) > 0
                readonly property bool urgent: workspace?.urgent ?? false
                // A workspace living on another monitor still gets a marker,
                // just a dimmer one.
                readonly property bool otherMonitor: !!workspace && workspace.monitor !== root.monitor

                implicitWidth: focused ? Theme.font.normal * 2.2 : Theme.font.normal * 1.4
                implicitHeight: Theme.barHeight - Theme.spacing.large
                Layout.preferredWidth: implicitWidth
                Layout.preferredHeight: implicitHeight

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: Theme.duration.normal
                        easing.type: Easing.OutBack
                    }
                }

                StyledRect {
                    anchors.fill: parent
                    radius: Theme.radius.full
                    color: {
                        if (pill.urgent)
                            return Theme.palette.urgent;
                        if (pill.focused)
                            return Theme.palette.accent;
                        if (state.containsMouse)
                            return Theme.palette.hover;
                        return "transparent";
                    }
                }

                StyledText {
                    anchors.centerIn: parent
                    text: pill.wsId
                    font.pointSize: Theme.font.small
                    font.bold: pill.focused
                    // Occupied workspaces show their number; empty ones fade
                    // back so the bar stays quiet.
                    opacity: pill.focused || pill.occupied ? 1 : 0.35
                    color: {
                        if (pill.urgent || pill.focused)
                            return Theme.palette.onAccent;
                        if (pill.otherMonitor)
                            return Theme.palette.muted;
                        return Theme.palette.subtext;
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Theme.duration.fast
                        }
                    }
                }

                StateLayer {
                    id: state
                    radius: Theme.radius.full
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: event => {
                        if (event.button === Qt.RightButton)
                            Hypr.moveTo(pill.wsId);
                        else
                            Hypr.switchTo(pill.wsId);
                    }
                }
            }
        }
    }

    // Scroll anywhere on the group to step through workspaces.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: event => {
            const current = root.monitor?.activeWorkspace?.id ?? 1;
            const next = event.angleDelta.y > 0 ? current - 1 : current + 1;
            if (next >= 1 && next <= Hypr.workspaceCount)
                Hypr.switchTo(next);
        }
    }
}
