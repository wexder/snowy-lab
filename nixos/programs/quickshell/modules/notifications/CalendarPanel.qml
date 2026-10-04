import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config
import qs.services as Services

// Month view hanging off the bar clock.
OverlayPanel {
    id: root

    shown: Services.Panels.calendar
    onDismissed: Services.Panels.close("calendar")

    placement: "top"
    panelWidth: 320
    panelHeight: 340

    // Month currently displayed, as an offset from the current month.
    property int monthOffset: 0
    onShownChanged: if (shown) monthOffset = 0

    readonly property date viewDate: {
        const now = Services.Time.now;
        return new Date(now.getFullYear(), now.getMonth() + monthOffset, 1);
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.large
        spacing: Theme.spacing.normal

        RowLayout {
            Layout.fillWidth: true

            IconButton {
                icon: "󰅁"
                iconColor: Theme.palette.subtext
                onClicked: root.monthOffset--
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDateTime(root.viewDate, "MMMM yyyy")
                font.pointSize: Theme.font.large
                font.bold: true
            }

            IconButton {
                icon: "󰅂"
                iconColor: Theme.palette.subtext
                onClicked: root.monthOffset++
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 7
            rowSpacing: Theme.spacing.tiny
            columnSpacing: 0

            Repeater {
                model: ["M", "T", "W", "T", "F", "S", "S"]

                delegate: StyledText {
                    required property string modelData
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font.pointSize: Theme.font.tiny
                    font.bold: true
                    color: Theme.palette.muted
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            rowSpacing: Theme.spacing.tiny
            columnSpacing: 0

            Repeater {
                // 6 weeks always, so the panel does not resize month to month.
                model: 42

                delegate: Item {
                    id: cell

                    required property int index

                    // Monday-first grid: how many blanks before the 1st.
                    readonly property int offset: (root.viewDate.getDay() + 6) % 7
                    readonly property date cellDate: new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), index - offset + 1)
                    readonly property bool inMonth: cellDate.getMonth() === root.viewDate.getMonth()
                    readonly property bool isToday: {
                        const now = Services.Time.now;
                        return cellDate.getDate() === now.getDate() && cellDate.getMonth() === now.getMonth() && cellDate.getFullYear() === now.getFullYear();
                    }

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    StyledRect {
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height)
                        height: width
                        radius: Theme.radius.full
                        color: cell.isToday ? Theme.palette.accent : "transparent"
                    }

                    StyledText {
                        anchors.centerIn: parent
                        text: cell.cellDate.getDate()
                        font.pointSize: Theme.font.small
                        font.bold: cell.isToday
                        color: cell.isToday ? Theme.palette.onAccent : cell.inMonth ? Theme.palette.text : Theme.palette.muted
                        opacity: cell.inMonth ? 1 : 0.4
                    }
                }
            }
        }
    }
}
