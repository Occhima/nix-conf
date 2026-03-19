import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Row {
    spacing: 4

    Shared.IconButton { icon: Services.Networking.icon }

    Separator {}

    Shared.IconButton {
        icon: Services.Bluetooth.icon
        onClicked: Data.Runtime.toggleBluetooth()
    }

    Separator {}

    Shared.IconButton { icon: Services.Pipewire.volumeIcon }

    Row {
        visible: Services.UPower.hasBattery
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Separator {}

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

    Separator {}

    Shared.IconButton {
        icon: "emblem-system-symbolic"
        onClicked: Data.Runtime.toggleQuickSettings()
    }

    component Separator: Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 12
        radius: 0.5
        color: Data.Settings.borderHover
    }
}
