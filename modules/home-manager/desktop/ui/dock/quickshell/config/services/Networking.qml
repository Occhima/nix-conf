pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "root:/data" as Data

Singleton {
    id: root

    property bool wifiEnabled: false
    property bool wifiConnected: false
    property string wifiSsid: ""
    property int wifiSignal: 0
    property bool ethernetConnected: false
    property string activeInterface: ""
    property string ipv4Address: ""
    property string gateway: ""
    property real downloadMbps: 0
    property real uploadMbps: 0

    readonly property bool connected: wifiConnected || ethernetConnected
    readonly property string icon: {
        if (ethernetConnected)
            return "network-wired"
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
        : wifiEnabled ? "Not Connected"
        : "WiFi Off"

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

    function setDetails(line: string): void {
        const separator = line.indexOf("=")
        if (separator < 0)
            return

        const key = line.slice(0, separator)
        const value = line.slice(separator + 1)
        switch (key) {
        case "ACTIVE_INTERFACE": activeInterface = value; break
        case "IPV4": ipv4Address = value; break
        case "GATEWAY": gateway = value; break
        case "DOWN_MBPS": downloadMbps = Number(value) || 0; break
        case "UP_MBPS": uploadMbps = Number(value) || 0; break
        }
    }

    function toggleWifi(): void {
        wifiToggle.command = ["nmcli", "radio", "wifi", wifiEnabled ? "off" : "on"]
        wifiToggle.running = true
    }

    function reload(): void {
        status.running = true
    }

    function reloadDetails(): void {
        if (!connected) {
            activeInterface = ""
            ipv4Address = ""
            gateway = ""
            downloadMbps = 0
            uploadMbps = 0
            return
        }
        details.running = true
    }

    Process {
        command: ["nmcli", "monitor"]
        running: true
        stdout: SplitParser {
            onRead: reloadTimer.restart()
        }
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
        stdout: SplitParser {
            onRead: line => root.setStatus(line)
        }
        onExited: {
            if (Data.Runtime.networkPopupVisible)
                root.reloadDetails()
        }
    }

    Process {
        id: details
        command: ["qs-network-details"]
        stdout: SplitParser {
            onRead: line => root.setDetails(line)
        }
    }

    Process {
        id: wifiToggle
        onExited: root.reload()
    }

    Connections {
        target: Data.Runtime

        function onNetworkPopupVisibleChanged(): void {
            if (Data.Runtime.networkPopupVisible)
                root.reloadDetails()
        }
    }
}
