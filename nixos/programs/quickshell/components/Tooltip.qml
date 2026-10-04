import QtQuick
import Quickshell
import qs.config

// Hover tooltip anchored under a bar item.
//
// The previous version referenced a `Globals` singleton that never existed, so
// tooltips silently failed to load.
Item {
    id: root

    // Set to the hovered item, or null to hide.
    required property Item relativeItem
    property string text
    property int showDelay: 400
    property int hideDelay: 120

    // Kept after relativeItem clears so the popup has a valid anchor while it
    // is being torn down.
    property Item displayItem: null
    property bool shouldShow: false

    // The tooltip is a popup window, not part of the bar's layout.
    width: 0
    height: 0
    visible: false

    onRelativeItemChanged: {
        if (relativeItem) {
            displayItem = relativeItem;
            hideTimer.stop();
            showTimer.restart();
        } else {
            showTimer.stop();
            hideTimer.restart();
        }
    }

    Timer {
        id: showTimer
        interval: root.showDelay
        onTriggered: root.shouldShow = true
    }

    Timer {
        id: hideTimer
        interval: root.hideDelay
        onTriggered: {
            root.shouldShow = false;
            root.displayItem = null;
        }
    }

    LazyLoader {
        active: root.shouldShow && root.displayItem !== null && root.text !== ""

        PopupWindow {
            visible: true
            color: "transparent"

            implicitWidth: body.implicitWidth
            implicitHeight: body.implicitHeight

            // Tooltips must never eat clicks meant for the item underneath.
            mask: Region {}

            anchor {
                window: root.displayItem?.QsWindow.window ?? null
                rect.x: root.displayItem ? anchor.window.contentItem.mapFromItem(root.displayItem, root.displayItem.width / 2, 0).x : 0
                rect.y: anchor.window?.height ?? 0
                edges: Edges.Top
                gravity: Edges.Bottom
                adjustment: PopupAdjustment.SlideX
            }

            StyledRect {
                id: body
                anchors.fill: parent
                implicitWidth: label.implicitWidth + Theme.spacing.large * 2
                implicitHeight: label.implicitHeight + Theme.spacing.normal * 2

                color: Theme.palette.elevated
                radius: Theme.radius.small
                border.width: 1
                border.color: Theme.palette.border

                StyledText {
                    id: label
                    anchors.centerIn: parent
                    text: root.text
                    font.pointSize: Theme.font.small
                    color: Theme.palette.subtext
                }
            }
        }
    }
}
