import QtQuick
import Quickshell
import "../services" as Services
import "../data" as Data

Image {
    visible: Services.UPower.hasBattery
    source: Quickshell.iconPath(Services.UPower.icon)
    width: 20
    height: 20
    sourceSize: Qt.size(20, 20)

    opacity: 0.9

    ToolTip {
        id: tooltip
        visible: mouseArea.containsMouse
        text: Services.UPower.tooltip
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
