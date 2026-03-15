import QtQuick
import Quickshell
import "root:/data" as Data

Rectangle {
    id: root

    property string icon: ""
    property int iconSize: 18
    property bool hovered: mouseArea.containsMouse

    signal clicked()

    width: 28
    height: 28
    radius: Data.Settings.rounding / 2
    color: hovered ? Qt.rgba(255, 255, 255, 0.1) : "transparent"

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Image {
        anchors.centerIn: parent
        source: root.icon ? Quickshell.iconPath(root.icon) : ""
        width: root.iconSize
        height: root.iconSize
        sourceSize: Qt.size(root.iconSize, root.iconSize)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
