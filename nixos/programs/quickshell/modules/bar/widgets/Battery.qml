import QtQuick
import qs.modules.bar
import qs.components
import qs.config
import qs.services as Services

BarBlock {
    id: root

    visible: Services.Battery.available
    interactive: false

    tooltipText: {
        const state = Services.Battery.charging ? "Charging" : Services.Battery.full ? "Full" : "Discharging";
        const parts = [state];
        if (Services.Battery.timeRemaining > 0)
            parts.push(`${Services.Time.relative(Services.Battery.timeRemaining)} ${Services.Battery.charging ? "until full" : "remaining"}`);
        if (Services.Battery.rate > 0.1)
            parts.push(`${Services.Battery.rate.toFixed(1)} W`);
        if (Services.Battery.fullRuntime > 0)
            parts.push(`${Services.Time.relative(Services.Battery.fullRuntime)} on a full charge`);
        return parts.join(" · ");
    }

    readonly property color statusColor: {
        switch (Services.Battery.level) {
        case "critical": return Theme.palette.error;
        case "low": return Theme.palette.warning;
        case "charging": return Theme.palette.success;
        default: return Theme.palette.text;
        }
    }

    Icon {
        text: Services.Battery.icon
        color: root.statusColor

        // Pulses when critical so it is noticeable without a notification.
        SequentialAnimation on opacity {
            running: Services.Battery.critical
            loops: Animation.Infinite
            alwaysRunToEnd: true
            NumberAnimation { to: 0.35; duration: 700; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 700; easing.type: Easing.InOutQuad }
        }
    }

    StyledText {
        text: `${Services.Battery.percent}%`
        font.pointSize: Theme.font.small
        color: root.statusColor
    }
}
