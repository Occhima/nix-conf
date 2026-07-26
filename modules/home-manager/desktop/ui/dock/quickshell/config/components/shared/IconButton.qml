import QtQuick
import Quickshell
import "root:/data" as Data

Rectangle {
    id: root

    property string icon
    property int iconSize: Data.Settings.iconLg
    property bool active: false
    property bool hovered: mouse.containsMouse

    signal clicked()

    width: 28
    height: 28
    radius: 7
    color: active
        ? Qt.alpha(Data.Settings.accentColor, hovered ? 0.22 : 0.14)
        : hovered ? Data.Settings.hoverBg : "transparent"
    border.width: active ? 1 : 0
    border.color: Qt.alpha(Data.Settings.accentColor, 0.32)
    opacity: enabled ? 1.0 : 0.35

    Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
    Behavior on opacity { NumberAnimation { duration: Data.Settings.animShort } }

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
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
