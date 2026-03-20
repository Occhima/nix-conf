import QtQuick
import Quickshell
import "root:/data" as Data

Rectangle {
    id: root

    property string icon
    property int iconSize: Data.Settings.iconLg
    property bool hovered: mouse.containsMouse

    signal clicked()

    width: 28
    height: 28
    radius: 7
    color: hovered ? Data.Settings.hoverBg : "transparent"

    Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }

    Image {
        anchors.centerIn: parent
        source: root.icon ? Quickshell.iconPath(root.icon) : ""
        width: root.iconSize
        height: root.iconSize
        sourceSize: Qt.size(root.iconSize, root.iconSize)
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
