import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.components
import qs.config

// Collapsible list used for both Wi-Fi networks and Bluetooth devices.
Item {
    id: root

    property bool expanded: false
    property var model: []
    property int rowHeight: 40
    property int maxVisibleRows: 5

    // Delegate contract: each row gets `modelData`.
    property Component rowDelegate

    Layout.fillWidth: true
    implicitHeight: expanded ? Math.min(root.model.length, root.maxVisibleRows) * root.rowHeight + Theme.spacing.small : 0
    clip: true

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Theme.duration.normal
            easing.type: Easing.OutCubic
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        anchors.topMargin: Theme.spacing.small
        clip: true
        model: root.expanded ? root.model : []
        delegate: root.rowDelegate

        ScrollBar.vertical: ScrollBar {
            policy: list.contentHeight > list.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
        }
    }
}
