import QtQuick
import Quickshell
import "../services" as Services
import "../data" as Data

Image {
    source: Quickshell.iconPath(Services.Pipewire.volumeIcon)
    width: 20
    height: 20
    sourceSize: Qt.size(20, 20)

    opacity: 0.9

    ToolTip {
        id: tooltip
        visible: mouseArea.containsMouse
        text: Math.round(Services.Pipewire.volume * 100) + "%"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Services.Pipewire.toggleMute()
    }
}
