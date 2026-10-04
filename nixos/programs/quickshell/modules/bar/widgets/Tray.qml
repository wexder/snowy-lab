import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.components
import qs.config

RowLayout {
    id: root

    spacing: Theme.spacing.tiny
    Layout.fillHeight: true

    Repeater {
        model: ScriptModel {
            values: [...SystemTray.items.values].filter(item => !Config.bar.trayBlacklist.includes(item.id))
        }

        delegate: MouseArea {
            id: delegate

            required property SystemTrayItem modelData

            Layout.fillHeight: true
            implicitWidth: Theme.font.icon + Theme.spacing.normal

            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    if (delegate.modelData.onlyMenu)
                        menuAnchor.open();
                    else
                        delegate.modelData.activate();
                } else if (event.button === Qt.MiddleButton) {
                    delegate.modelData.secondaryActivate();
                } else {
                    menuAnchor.open();
                }
            }

            onWheel: event => {
                event.accepted = true;
                delegate.modelData.scroll(event.angleDelta.y / 120, false);
            }

            StyledRect {
                anchors.fill: parent
                anchors.topMargin: Theme.spacing.small
                anchors.bottomMargin: Theme.spacing.small
                radius: Theme.radius.small
                color: delegate.containsMouse ? Theme.palette.hover : "transparent"
            }

            IconImage {
                anchors.centerIn: parent
                source: delegate.modelData.icon
                implicitSize: Theme.font.icon
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: delegate.modelData.menu
                anchor.window: delegate.QsWindow.window
                anchor.adjustment: PopupAdjustment.Flip
                anchor.onAnchoring: {
                    const window = delegate.QsWindow.window;
                    menuAnchor.anchor.rect = window.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height);
                }
            }

            Tooltip {
                relativeItem: delegate.containsMouse ? delegate : null
                text: delegate.modelData.tooltipTitle || delegate.modelData.title || delegate.modelData.id
            }
        }
    }
}
