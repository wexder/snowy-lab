import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config

// Full-screen overlay hosting a floating panel: used by the launcher, control
// centre and notification centre. Handles reveal animation, click-outside
// dismissal and Escape for all of them.
PanelWindow {
    id: root

    default property alias content: contentContainer.data

    property bool shown: false
    // "top" | "topRight" | "topLeft" | "center"
    property string placement: "topRight"
    property int panelWidth: 380
    property int panelHeight: 480
    property int gap: Theme.spacing.normal
    property bool grabKeyboard: false

    // 0..1, drives the open/close animation.
    property real reveal: 0

    signal dismissed

    function close(): void {
        root.shown = false;
    }

    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:overlay"
    WlrLayershell.keyboardFocus: root.grabKeyboard && root.shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    onShownChanged: {
        if (shown)
            visible = true;
        revealAnim.to = shown ? 1 : 0;
        revealAnim.restart();
    }

    NumberAnimation {
        id: revealAnim
        target: root
        property: "reveal"
        duration: Theme.duration.normal
        easing.type: Easing.OutCubic
        onFinished: {
            if (!root.shown) {
                root.visible = false;
                root.dismissed();
            }
        }
    }

    // Click anywhere outside the panel to dismiss.
    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    FocusScope {
        anchors.fill: parent
        focus: root.shown

        Keys.onEscapePressed: root.close()

        Item {
            id: panel

            width: root.panelWidth
            height: root.panelHeight

            opacity: root.reveal
            // Slides in from the edge it is anchored to.
            transform: Translate {
                y: (1 - root.reveal) * -16
            }

            anchors {
                top: root.placement !== "center" ? parent.top : undefined
                topMargin: root.placement !== "center" ? Theme.barInsetTop + root.gap : 0
                right: root.placement === "topRight" ? parent.right : undefined
                rightMargin: Theme.spacing.large
                left: root.placement === "topLeft" ? parent.left : undefined
                leftMargin: Theme.spacing.large
                horizontalCenter: root.placement === "top" || root.placement === "center" ? parent.horizontalCenter : undefined
                verticalCenter: root.placement === "center" ? parent.verticalCenter : undefined
            }

            // Swallows clicks so they do not reach the dismiss handler behind.
            MouseArea {
                anchors.fill: parent
            }

            StyledRect {
                id: contentContainer
                anchors.fill: parent
                color: Theme.palette.backgroundSolid
                radius: Theme.radius.large
                border.width: 1
                border.color: Theme.palette.border
                clip: true
            }
        }
    }
}
