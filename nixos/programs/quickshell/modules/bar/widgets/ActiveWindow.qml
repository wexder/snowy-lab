import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.bar
import qs.components
import qs.config
import qs.services

// Focused window's icon and title, driven by Hyprland events rather than a
// `hyprctl activewindow | grep | sed` subprocess per event.
BarBlock {
    id: root

    // Set by the bar so the title can shrink when the bar gets crowded.
    property int availableWidth: 400

    readonly property DesktopEntry entry: Hypr.activeClass ? DesktopEntries.heuristicLookup(Hypr.activeClass) : null

    visible: Hypr.activeTitle !== ""
    interactive: false
    tooltipText: Hypr.activeTitle

    IconImage {
        implicitSize: Theme.font.icon
        source: root.entry?.icon ? Quickshell.iconPath(root.entry.icon, true) : ""
        visible: source !== ""
    }

    StyledText {
        text: Hypr.activeTitle
        color: Theme.palette.subtext
        font.pointSize: Theme.font.small
        elide: Text.ElideRight
        maximumLineCount: 1
        // Bounded by what the bar has spare, so a long title never pushes the
        // right-hand widgets off screen.
        Layout.maximumWidth: Math.max(0, root.availableWidth)
    }
}
