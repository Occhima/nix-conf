import QtQuick
import QtQuick.Layouts
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

GridLayout {
    columns: 2
    columnSpacing: 10
    rowSpacing: 10

    Shared.QuickToggle {
        Layout.fillWidth: true
        icon: "network-wireless-symbolic"
        label: "Wi-Fi"
        subLabel: Services.Networking.wifiConnected ? Services.Networking.wifiSsid : "Disconnected"
        active: Services.Networking.wifiEnabled
        activeColor: Data.Settings.accentColor
        onClicked: Services.Networking.toggleWifi()
    }

    Shared.QuickToggle {
        Layout.fillWidth: true
        icon: "bluetooth-symbolic"
        label: "Bluetooth"
        subLabel: Services.Bluetooth.connected ? (Services.Bluetooth.connectedDevice?.name ?? "Connected") : (Services.Bluetooth.powered ? "On" : "Off")
        active: Services.Bluetooth.powered
        activeColor: Data.Settings.accentColor
        onClicked: Services.Bluetooth.toggle()
    }

    Shared.QuickToggle {
        Layout.fillWidth: true
        icon: "notifications-disabled-symbolic"
        label: "Do Not Disturb"
        subLabel: Services.Notifications.dnd ? "On" : "Off"
        active: Services.Notifications.dnd
        activeColor: Data.Settings.warningColor
        onClicked: Services.Notifications.toggleDnd()
    }

    Shared.QuickToggle {
        Layout.fillWidth: true
        icon: Services.Pipewire.sinkReady ? Services.Pipewire.volumeIcon : "audio-volume-muted-symbolic"
        label: Services.Pipewire.muted ? "Muted" : "Sound"
        subLabel: {
            if (!Services.Pipewire.sinkReady) return "Unavailable"
            if (Services.Pipewire.muted) return "Tap to unmute"
            return Math.round(Services.Pipewire.volume * 100) + "%"
        }
        active: Services.Pipewire.muted
        activeColor: Data.Settings.errorColor
        onClicked: Services.Pipewire.toggleMute()
    }
}
