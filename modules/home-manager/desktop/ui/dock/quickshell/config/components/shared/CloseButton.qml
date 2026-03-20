import QtQuick
import Quickshell
import "root:/data" as Data

Rectangle {
    id: root

    property bool useIcon: true

    implicitWidth: 28
    implicitHeight: 28
    radius: 14

    color: closeMouseArea.containsMouse
        ? Qt.alpha(Data.Settings.errorColor, 0.18)
        : Qt.alpha(Data.Settings.fgColor, 0.05)

    border.width: 1
    border.color: closeMouseArea.containsMouse
        ? Qt.alpha(Data.Settings.errorColor, 0.28)
        : Qt.alpha(Data.Settings.fgColor, 0.08)

    Behavior on color {
        ColorAnimation { duration: Data.Settings.animShort }
    }

    Behavior on border.color {
        ColorAnimation { duration: Data.Settings.animShort }
    }

    Image {
        anchors.centerIn: parent
        source: Quickshell.iconPath("window-close-symbolic")
        width: Data.Settings.iconMd
        height: Data.Settings.iconMd
        sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
        visible: root.useIcon
    }

    Text {
        anchors.centerIn: parent
        text: "\u00d7"
        color: Data.Settings.fgColor
        font.pixelSize: 16
        font.weight: Font.DemiBold
        visible: !root.useIcon
    }

    MouseArea {
        id: closeMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
            mouse.accepted = true
            Data.Runtime.closeAll()
        }
    }
}
