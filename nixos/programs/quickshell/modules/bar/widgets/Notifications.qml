import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services as Services

BarBlock {
    id: root

    signal toggleCenter

    tooltipText: Services.Notifs.doNotDisturb ? "Do not disturb — right click to re-enable" : Services.Notifs.count > 0 ? `${Services.Notifs.count} notification${Services.Notifs.count === 1 ? "" : "s"}` : "No notifications"

    onClicked: event => {
        if (event.button === Qt.RightButton)
            Services.Notifs.toggleDnd();
        else
            root.toggleCenter();
    }

    Icon {
        text: Services.Notifs.icon
        color: {
            if (Services.Notifs.doNotDisturb)
                return Theme.palette.muted;
            if (Services.Notifs.hasUrgent)
                return Theme.palette.urgent;
            return Services.Notifs.count > 0 ? Theme.palette.accent : Theme.palette.text;
        }
    }

    StyledText {
        visible: Services.Notifs.count > 0
        text: Services.Notifs.count
        font.pointSize: Theme.font.small
        color: Theme.palette.subtext
    }
}
