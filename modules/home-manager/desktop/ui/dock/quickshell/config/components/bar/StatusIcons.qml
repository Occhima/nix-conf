import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Row {
    spacing: 2

    // Volume
    Shared.IconButton {
        icon: Services.Pipewire.volumeIcon
        onClicked: Data.Runtime.toggleQuickSettings()

        ToolTip {
            visible: parent.hovered
            text: Math.round(Services.Pipewire.volume * 100) + "%"
        }
    }

    // Network
    Shared.IconButton {
        icon: Services.Networking.icon
        onClicked: Data.Runtime.toggleQuickSettings()

        ToolTip {
            visible: parent.hovered
            text: Services.Networking.statusText
        }
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

    // Battery (only if present)
    Shared.IconButton {
        visible: Services.UPower.hasBattery
        icon: Services.UPower.icon
        onClicked: {} // Just tooltip

        ToolTip {
            visible: parent.hovered
            text: Services.UPower.tooltip
        }
    }
}
