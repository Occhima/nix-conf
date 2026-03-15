import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Row {
    spacing: 4

    // Network
    Shared.IconButton {
        icon: Services.Networking.icon
        onClicked: Data.Runtime.toggleQuickSettings()

        ToolTip {
            visible: parent.hovered
            text: Services.Networking.statusText
        }
    }

    // Separator
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 12
        radius: 0.5
        color: Qt.rgba(255, 255, 255, 0.12)
    }

    // Bluetooth
    Shared.IconButton {
        icon: Services.Bluetooth.icon
        onClicked: Data.Runtime.toggleQuickSettings()

        ToolTip {
            visible: parent.hovered
            text: Services.Bluetooth.statusText
        }
    }

    // Separator
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 12
        radius: 0.5
        color: Qt.rgba(255, 255, 255, 0.12)
    }

    // Volume
    Shared.IconButton {
        icon: Services.Pipewire.volumeIcon
        onClicked: Data.Runtime.toggleQuickSettings()

        ToolTip {
            visible: parent.hovered
            text: Math.round(Services.Pipewire.volume * 100) + "%"
        }
    }

    // Battery (only if present) with percentage
    Row {
        visible: Services.UPower.hasBattery
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 1
            height: 12
            radius: 0.5
            color: Qt.rgba(255, 255, 255, 0.12)
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: Quickshell.iconPath(Services.UPower.icon)
            width: 16
            height: 16
            sourceSize: Qt.size(16, 16)
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(Services.UPower.percentage) + "%"
            color: Data.Settings.fgColor
            font.pixelSize: 11
            font.weight: Font.Medium
        }
    }
}
