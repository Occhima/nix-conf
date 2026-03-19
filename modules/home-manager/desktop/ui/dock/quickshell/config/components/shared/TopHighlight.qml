import QtQuick

Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 1
    height: parent.height / 2
    radius: parent.radius - 1
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
        GradientStop { position: 1.0; color: "transparent" }
    }
}
