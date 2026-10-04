import QtQuick
import qs.config

Rectangle {
    color: "transparent"
    radius: Theme.radius.normal
    antialiasing: true

    Behavior on color {
        ColorAnimation {
            duration: Theme.duration.fast
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: Theme.duration.fast
        }
    }
}
