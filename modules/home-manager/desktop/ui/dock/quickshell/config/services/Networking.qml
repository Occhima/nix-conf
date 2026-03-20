pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property bool wifiEnabled: false
    property bool wifiConnected: false
    property string wifiSsid: ""
    property int wifiSignal: 0

    property bool ethernetConnected: false
    property string ethernetDevice: ""

    readonly property bool connected: wifiConnected || ethernetConnected

    readonly property string connectionType: {
        if (ethernetConnected) return "ethernet"
        if (wifiConnected) return "wifi"
        return "none"
    }

    readonly property string icon: {
        if (ethernetConnected) return "network-wired-symbolic"
        if (wifiConnected) {
            if (wifiSignal >= 75) return "network-wireless-signal-excellent-symbolic"
            if (wifiSignal >= 50) return "network-wireless-signal-good-symbolic"
            if (wifiSignal >= 25) return "network-wireless-signal-ok-symbolic"
            return "network-wireless-signal-weak-symbolic"
        }
        if (wifiEnabled) return "network-wireless-offline-symbolic"
        return "network-offline-symbolic"
    }

    readonly property string statusText: {
        if (ethernetConnected) return "Ethernet"
        if (wifiConnected) return wifiSsid
        if (wifiEnabled) return "Not Connected"
        return "WiFi Off"
    }

    function toggleWifi() {
        wifiToggleProc.command = ["nmcli", "radio", "wifi", wifiEnabled ? "off" : "on"]
        wifiToggleProc.running = true
    }

    function reload() { statusProc.running = true }

    property var monitor: Process {
        command: ["nmcli", "monitor"]
        running: true
        stdout: SplitParser { onRead: data => reloadTimer.restart() }
    }

    property var reloadTimer: Timer {
        interval: 200
        onTriggered: root.reload()
    }

    property var statusProc: Process {
        command: ["bash", Quickshell.shellDir + "/services/scripts/network-status.sh"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const parts = line.split("=")
                if (parts.length !== 2) return
                const [key, value] = parts

                switch (key) {
                    case "WIFI_ENABLED": root.wifiEnabled = value === "enabled"; break
                    case "WIFI_CONNECTED": root.wifiConnected = value === "yes"; break
                    case "WIFI_SSID": root.wifiSsid = value; break
                    case "WIFI_SIGNAL": root.wifiSignal = parseInt(value) || 0; break
                    case "ETH_CONNECTED": root.ethernetConnected = value === "yes"; break
                    case "ETH_DEVICE": root.ethernetDevice = value; break
                }
            }
        }
    }

    property var wifiToggleProc: Process { onExited: root.reload() }

    Component.onCompleted: reload()
}
