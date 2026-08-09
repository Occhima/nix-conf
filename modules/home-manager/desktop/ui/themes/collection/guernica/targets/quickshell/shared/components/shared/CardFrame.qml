import QtQuick
import "root:/data" as Data

Rectangle {
    id: root

    property real highlightOpacity: 0.03

    radius: 18
    clip: true
    color: Data.Settings.bgLightTranslucent
    border.width: 1
    border.color: Qt.alpha(Data.Settings.fgColor, 0.07)

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 1
        height: parent.height / 2
        radius: parent.radius - 1
        color: "transparent"

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Qt.alpha("white", root.highlightOpacity)
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }
}
