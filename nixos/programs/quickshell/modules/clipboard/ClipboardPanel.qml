import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services as Services

// Clipboard history picker: the same list/decode/copy the wofi pipeline did,
// with the launcher's search field and keyboard navigation.
OverlayPanel {
    id: root

    shown: Services.Panels.clipboard
    onDismissed: Services.Panels.close("clipboard")

    placement: "top"
    panelWidth: 560
    panelHeight: 460
    grabKeyboard: true

    property string query: ""
    property int selectedIndex: 0

    readonly property var results: Services.Clip.search(query)

    onShownChanged: {
        if (shown) {
            query = "";
            selectedIndex = 0;
            // The history changes as you copy, so re-read it on every open.
            Services.Clip.refresh();
            input.forceActiveFocus();
        }
    }

    onResultsChanged: selectedIndex = 0

    function activate(): void {
        const entry = root.results[root.selectedIndex];
        if (!entry)
            return;
        Services.Clip.copy(entry);
        root.close();
    }

    function move(delta: int): void {
        const count = root.results.length;
        if (count === 0)
            return;
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
                    text: "󰅍"
                    color: Theme.palette.accent
                }

                TextField {
                    id: input

                    Layout.fillWidth: true
                    focus: true
                    background: null
                    placeholderText: "Search clipboard history…"
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
                    visible: root.results.length > 0
                    text: root.results.length
                    font.pointSize: Theme.font.tiny
                    color: Theme.palette.muted
                }
            }
        }

        // ── Entries ──
        ListView {
            id: list

            Layout.fillWidth: true
            Layout.fillHeight: true

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
                implicitHeight: 40
                radius: Theme.radius.small
                color: selected ? Theme.palette.surfaceAlt : entryState.containsMouse ? Theme.palette.hover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.large
                    anchors.rightMargin: Theme.spacing.large
                    spacing: Theme.spacing.large

                    Icon {
                        text: entryRow.modelData.binary ? "󰋩" : "󰦨"
                        sizeMultiplier: 0.8
                        color: Theme.palette.muted
                    }

                    StyledText {
                        Layout.fillWidth: true
                        // cliphist previews are already single-line and
                        // truncated, so this only has to elide to the panel.
                        text: entryRow.modelData.preview
                        font.pointSize: Theme.font.small
                        font.family: entryRow.modelData.binary ? Theme.font.family : Theme.font.mono
                        elide: Text.ElideRight
                        color: entryRow.modelData.binary ? Theme.palette.muted : Theme.palette.text
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
            visible: root.results.length === 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: Services.Clip.loading ? "Reading clipboard history…" : root.query ? `No matches for “${root.query}”` : "Clipboard history is empty"
            color: Theme.palette.muted
        }
    }
}
