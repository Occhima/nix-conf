import QtQuick
import Quickshell
import "../services" as Services
import "../data" as Data

Item {
    visible: Services.Notifications.count > 0 || Services.Notifications.dnd
    width: 20
    height: 20

    Image {
        anchors.fill: parent
        source: Quickshell.iconPath(Services.Notifications.icon)
        sourceSize: Qt.size(20, 20)
        opacity: 0.9
    }

    Rectangle {
        visible: Services.Notifications.count > 0 && !Services.Notifications.dnd
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: -2
        anchors.rightMargin: -2
        width: 8
        height: 8
        radius: 4
        color: Data.Settings.errorColor
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Services.Notifications.toggleDnd()
    }
}
