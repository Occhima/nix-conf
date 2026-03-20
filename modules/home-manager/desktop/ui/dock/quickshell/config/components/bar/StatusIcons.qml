import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Row {
    spacing: Data.Settings.spacingXs

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
        spacing: Data.Settings.spacingXs
        anchors.verticalCenter: parent.verticalCenter

        Separator {}

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: Quickshell.iconPath(Services.UPower.icon)
            width: Data.Settings.iconMd
            height: Data.Settings.iconMd
            sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(Services.UPower.percentage) + "%"
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontSm
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
