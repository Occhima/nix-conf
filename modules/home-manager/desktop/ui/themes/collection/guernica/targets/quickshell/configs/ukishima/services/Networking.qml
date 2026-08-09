pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool wifiEnabled: false
    property bool wifiConnected: false
    property string wifiSsid: ""
    property int wifiSignal: 0
    property bool ethernetConnected: false

    readonly property bool connected: wifiConnected || ethernetConnected
    readonly property string icon: {
        if (ethernetConnected)
            return "network-wired-symbolic"
        if (wifiConnected) {
            if (wifiSignal >= 75)
                return "network-wireless-signal-excellent-symbolic"
            if (wifiSignal >= 50)
                return "network-wireless-signal-good-symbolic"
            if (wifiSignal >= 25)
                return "network-wireless-signal-ok-symbolic"
            return "network-wireless-signal-weak-symbolic"
        }
        return wifiEnabled
            ? "network-wireless-offline-symbolic"
            : "network-offline-symbolic"
    }
    readonly property string statusText: ethernetConnected ? "Ethernet"
        : wifiConnected ? wifiSsid
        : wifiEnabled ? "Not connected"
        : "Wi-Fi off"

    function setStatus(line: string): void {
        const separator = line.indexOf("=")
        if (separator < 0)
            return

        const key = line.slice(0, separator)
        const value = line.slice(separator + 1)
        switch (key) {
        case "WIFI_ENABLED": wifiEnabled = value === "enabled"; break
        case "WIFI_CONNECTED": wifiConnected = value === "yes"; break
        case "WIFI_SSID": wifiSsid = value; break
        case "WIFI_SIGNAL": wifiSignal = parseInt(value) || 0; break
        case "ETH_CONNECTED": ethernetConnected = value === "yes"; break
        }
    }

    function reload(): void { status.running = true }

    function toggleWifi(): void {
        wifiToggle.command = ["nmcli", "radio", "wifi", wifiEnabled ? "off" : "on"]
        wifiToggle.running = true
    }

    Process {
        command: ["nmcli", "monitor"]
        running: true
        stdout: SplitParser { onRead: reloadTimer.restart() }
    }

    Timer {
        id: reloadTimer
        interval: 200
        onTriggered: root.reload()
    }

    Process {
        id: status
        command: ["qs-network-status"]
        running: true
        stdout: SplitParser { onRead: line => root.setStatus(line) }
    }

    Process {
        id: wifiToggle
        onExited: root.reload()
    }
}
