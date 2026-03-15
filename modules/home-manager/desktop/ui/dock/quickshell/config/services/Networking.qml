pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    // WiFi state
    property bool wifiEnabled: false
    property bool wifiConnected: false
    property string wifiSsid: ""
    property int wifiSignal: 0

    // Ethernet state
    property bool ethernetConnected: false
    property string ethernetDevice: ""

    // Combined state
    readonly property bool connected: wifiConnected || ethernetConnected
    readonly property string connectionType: {
        if (ethernetConnected) return "ethernet"
        if (wifiConnected) return "wifi"
        return "none"
    }

    readonly property string icon: {
        if (ethernetConnected) {
            return "network-wired-symbolic"
        }
        if (wifiConnected) {
            if (wifiSignal >= 75) return "network-wireless-signal-excellent-symbolic"
            if (wifiSignal >= 50) return "network-wireless-signal-good-symbolic"
            if (wifiSignal >= 25) return "network-wireless-signal-ok-symbolic"
            return "network-wireless-signal-weak-symbolic"
        }
        if (wifiEnabled) {
            return "network-wireless-offline-symbolic"
        }
        return "network-offline-symbolic"
    }

    readonly property string statusText: {
        if (ethernetConnected) return "Ethernet"
        if (wifiConnected) return wifiSsid
        if (wifiEnabled) return "Not Connected"
        return "WiFi Off"
    }

    function toggleWifi() {
        const newState = wifiEnabled ? "off" : "on"
        wifiToggleProc.command = ["nmcli", "radio", "wifi", newState]
        wifiToggleProc.running = true
    }

    function reload() {
        statusProc.running = true
    }

    // Monitor network changes
    property var monitor: Process {
        command: ["nmcli", "monitor"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                // Debounce updates
                reloadTimer.restart()
            }
        }
    }

    property var reloadTimer: Timer {
        interval: 200
        onTriggered: root.reload()
    }

    // Check network status
    property var statusProc: Process {
        command: ["bash", "-c", `
            # WiFi status
            WIFI_ENABLED=$(nmcli radio wifi)
            WIFI_INFO=$(nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep '^yes' | head -1)

            # Ethernet status
            ETH_INFO=$(nmcli -t -f type,state,device con show --active 2>/dev/null | grep '^.*ethernet.*activated' | head -1)

            echo "WIFI_ENABLED=$WIFI_ENABLED"
            if [ -n "$WIFI_INFO" ]; then
                SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
                SIGNAL=$(echo "$WIFI_INFO" | cut -d: -f3)
                echo "WIFI_CONNECTED=yes"
                echo "WIFI_SSID=$SSID"
                echo "WIFI_SIGNAL=$SIGNAL"
            else
                echo "WIFI_CONNECTED=no"
            fi

            if [ -n "$ETH_INFO" ]; then
                ETH_DEV=$(echo "$ETH_INFO" | cut -d: -f3)
                echo "ETH_CONNECTED=yes"
                echo "ETH_DEVICE=$ETH_DEV"
            else
                echo "ETH_CONNECTED=no"
            fi
        `]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const parts = line.split("=")
                if (parts.length !== 2) return
                const key = parts[0]
                const value = parts[1]

                switch (key) {
                    case "WIFI_ENABLED":
                        root.wifiEnabled = (value === "enabled")
                        break
                    case "WIFI_CONNECTED":
                        root.wifiConnected = (value === "yes")
                        break
                    case "WIFI_SSID":
                        root.wifiSsid = value
                        break
                    case "WIFI_SIGNAL":
                        root.wifiSignal = parseInt(value) || 0
                        break
                    case "ETH_CONNECTED":
                        root.ethernetConnected = (value === "yes")
                        break
                    case "ETH_DEVICE":
                        root.ethernetDevice = value
                        break
                }
            }
        }
    }

    property var wifiToggleProc: Process {
        onExited: root.reload()
    }

    Component.onCompleted: {
        reload()
    }
}
