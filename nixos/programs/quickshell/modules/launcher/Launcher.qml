import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.config
import qs.services as Services

// Application launcher: fuzzy search over DesktopEntries with keyboard
// navigation and an inline calculator.
OverlayPanel {
    id: root

    shown: Services.Panels.launcher
    onDismissed: Services.Panels.close("launcher")

    placement: "top"
    panelWidth: 560
    panelHeight: 460
    grabKeyboard: true

    property string query: ""
    property int selectedIndex: 0

    readonly property list<var> results: Services.Apps.search(query)
    readonly property bool isCalculation: Services.Calc.isExpression(query)
    readonly property string calcResult: isCalculation ? Services.Calc.evaluate(query) : ""

    onShownChanged: {
        if (shown) {
            query = "";
            selectedIndex = 0;
            input.forceActiveFocus();
        }
    }

    onResultsChanged: selectedIndex = 0

    function activate(): void {
        if (root.calcResult) {
            Quickshell.clipboardText = root.calcResult;
            root.close();
            return;
        }
        const entry = root.results[root.selectedIndex];
        if (!entry)
            return;
        Services.Apps.launch(entry);
        root.close();
    }

    function move(delta: int): void {
        const count = root.results.length;
        if (count === 0)
            return;
        // Wraps, so holding a direction cycles rather than sticking at the end.
        root.selectedIndex = (root.selectedIndex + delta + count) % count;
        list.positionViewAtIndex(root.selectedIndex, ListView.Contain);
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.large
        spacing: Theme.spacing.normal

        // ── Search field ──
        StyledRect {
            Layout.fillWidth: true
            implicitHeight: 46
            radius: Theme.radius.normal
            color: Theme.palette.surface

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacing.large
                anchors.rightMargin: Theme.spacing.large
                spacing: Theme.spacing.normal

                Icon {
                    text: root.isCalculation ? "󰃬" : "󰍉"
                    color: Theme.palette.accent
                }

                TextField {
                    id: input

                    Layout.fillWidth: true
                    focus: true
                    background: null
                    placeholderText: "Search applications…"
                    placeholderTextColor: Theme.palette.muted
                    color: Theme.palette.text
                    font.family: Theme.font.family
                    font.pointSize: Theme.font.normal
                    selectByMouse: true
                    selectionColor: Theme.palette.accent
                    selectedTextColor: Theme.palette.onAccent

                    onTextChanged: root.query = text

                    Keys.onDownPressed: root.move(1)
                    Keys.onUpPressed: root.move(-1)
                    Keys.onEscapePressed: root.close()
                    Keys.onReturnPressed: root.activate()
                    Keys.onEnterPressed: root.activate()
                    // Ctrl-N / Ctrl-P for people who never leave the home row.
                    Keys.onPressed: event => {
                        if (event.modifiers & Qt.ControlModifier) {
                            if (event.key === Qt.Key_N) {
                                root.move(1);
                                event.accepted = true;
                            } else if (event.key === Qt.Key_P) {
                                root.move(-1);
                                event.accepted = true;
                            }
                        }
                    }
                }

                StyledText {
                    visible: root.results.length > 0 && !root.calcResult
                    text: root.results.length
                    font.pointSize: Theme.font.tiny
                    color: Theme.palette.muted
                }
            }
        }

        // ── Calculator result ──
        StyledRect {
            Layout.fillWidth: true
            visible: root.calcResult !== ""
            implicitHeight: 56
            radius: Theme.radius.normal
            color: Theme.palette.surface

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacing.large
                anchors.rightMargin: Theme.spacing.large
                spacing: Theme.spacing.normal

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    StyledText {
                        text: root.calcResult
                        font.pointSize: Theme.font.title
                        font.bold: true
                        color: Theme.palette.accent
                    }

                    StyledText {
                        text: "Enter to copy"
                        font.pointSize: Theme.font.tiny
                        color: Theme.palette.muted
                    }
                }
            }
        }

        // ── Results ──
        ListView {
            id: list

            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !root.calcResult

            clip: true
            spacing: Theme.spacing.tiny
            model: root.results
            currentIndex: root.selectedIndex

            ScrollBar.vertical: ScrollBar {
                policy: list.contentHeight > list.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            }

            delegate: StyledRect {
                id: entryRow

                required property int index
                required property var modelData
                readonly property bool selected: index === root.selectedIndex

                width: list.width
                implicitHeight: 48
                radius: Theme.radius.small
                color: selected ? Theme.palette.surfaceAlt : entryState.containsMouse ? Theme.palette.hover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.large
                    anchors.rightMargin: Theme.spacing.large
                    spacing: Theme.spacing.large

                    IconImage {
                        implicitSize: 28
                        source: entryRow.modelData.icon ? Quickshell.iconPath(entryRow.modelData.icon, true) : ""
                        visible: source !== ""
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        StyledText {
                            Layout.fillWidth: true
                            text: entryRow.modelData.name
                            font.pointSize: Theme.font.small
                            font.bold: entryRow.selected
                        }

                        StyledText {
                            Layout.fillWidth: true
                            visible: text !== ""
                            text: entryRow.modelData.genericName || entryRow.modelData.comment || ""
                            font.pointSize: Theme.font.tiny
                            color: Theme.palette.muted
                        }
                    }

                    Icon {
                        visible: entryRow.selected
                        text: "󰌑"
                        sizeMultiplier: 0.8
                        color: Theme.palette.muted
                    }
                }

                StateLayer {
                    id: entryState
                    radius: Theme.radius.small
                    hoverColor: "transparent"
                    pressColor: "transparent"
                    onEntered: root.selectedIndex = entryRow.index
                    onClicked: {
                        root.selectedIndex = entryRow.index;
                        root.activate();
                    }
                }
            }
        }

        // ── Empty state ──
        StyledText {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.results.length === 0 && !root.calcResult
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.query ? `No matches for “${root.query}”` : "No applications found"
            color: Theme.palette.muted
        }
    }
}
