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
        Layout.columnSpan: Data.Settings.notificationsEnabled ? 1 : 2
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

    Shared.QuickToggle {
        Layout.fillWidth: true
        visible: Data.Settings.notificationsEnabled
        icon: Services.Notifications.icon
        label: "Do not disturb"
        subLabel: Services.Notifications.dnd
            ? "On"
            : `${Services.Notifications.count} saved`
        active: Services.Notifications.dnd
        activeColor: Data.Settings.purpleColor
        onClicked: Services.Notifications.toggleDnd()
    }
}
