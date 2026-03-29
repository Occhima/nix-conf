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

    property string activeInterface: ""
    property string ipv4Address: ""
    property string gateway: ""
    property real downloadKbps: 0
    property real uploadKbps: 0

    property real _lastRxBytes: 0
    property real _lastTxBytes: 0
    property real _lastSampleMs: 0

    readonly property bool connected: wifiConnected || ethernetConnected

    readonly property string connectionType: {
        if (ethernetConnected) return "ethernet"
        if (wifiConnected) return "wifi"
        return "none"
    }

    readonly property string icon: {
        if (ethernetConnected) return "network-wired"
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

    function reloadDetails() {
        if (!connected) {
            activeInterface = ""
            ipv4Address = ""
            gateway = ""
            downloadKbps = 0
            uploadKbps = 0
            _lastRxBytes = 0
            _lastTxBytes = 0
            _lastSampleMs = 0
            return
        }

        ifaceProc.running = true
    }

    function parseRouteInterface(routeLine: string): string {
        const parts = routeLine.trim().split(/\s+/)
        const devIdx = parts.indexOf("dev")
        if (devIdx >= 0 && parts.length > devIdx + 1) return parts[devIdx + 1]
        return ""
    }

    function parseIpv4(addrLine: string): string {
        const fields = addrLine.trim().split(/\s+/)
        if (fields.length < 4) return ""
        return fields[3].split("/")[0]
    }

    function parseGateway(routeLine: string): string {
        const parts = routeLine.trim().split(/\s+/)
        const viaIdx = parts.indexOf("via")
        if (viaIdx >= 0 && parts.length > viaIdx + 1) return parts[viaIdx + 1]
        return ""
    }

    function parseNumber(line: string): real {
        return Number(line.trim()) || 0
    }

    function updateRates(rxBytes: real, txBytes: real): void {
        const now = Date.now()

        if (_lastSampleMs <= 0 || now <= _lastSampleMs) {
            _lastRxBytes = rxBytes
            _lastTxBytes = txBytes
            _lastSampleMs = now
            downloadKbps = 0
            uploadKbps = 0
            return
        }

        const elapsedMs = now - _lastSampleMs
        const elapsedSec = elapsedMs / 1000
        if (elapsedSec <= 0) return

        const rxDelta = Math.max(0, rxBytes - _lastRxBytes)
        const txDelta = Math.max(0, txBytes - _lastTxBytes)

        downloadKbps = rxDelta / elapsedSec / 1024
        uploadKbps = txDelta / elapsedSec / 1024

        _lastRxBytes = rxBytes
        _lastTxBytes = txBytes
        _lastSampleMs = now
    }

    property var monitor: Process {
        command: ["nmcli", "monitor"]
        running: true
        stdout: SplitParser { onRead: data => reloadTimer.restart() }
    }

    property var reloadTimer: Timer {
        interval: 200
        onTriggered: root.reload()
    }

    property var detailsTimer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.reloadDetails()
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
        onExited: root.reloadDetails()
    }

    property var ifaceProc: Process {
        command: ["ip", "route", "get", "1.1.1.1"]
        stdout: SplitParser {
            onRead: line => {
                const iface = root.parseRouteInterface(line)
                if (iface !== root.activeInterface) {
                    root.activeInterface = iface
                    root._lastSampleMs = 0
                }

                if (!iface) {
                    root.ipv4Address = ""
                    root.gateway = ""
                    root.downloadKbps = 0
                    root.uploadKbps = 0
                    return
                }

                addrProc.command = ["ip", "-4", "-o", "addr", "show", "dev", iface]
                addrProc.running = true

                gatewayProc.command = ["ip", "route", "show", "default", "dev", iface]
                gatewayProc.running = true

                rxProc.command = ["cat", "/sys/class/net/" + iface + "/statistics/rx_bytes"]
                rxProc.running = true

                txProc.command = ["cat", "/sys/class/net/" + iface + "/statistics/tx_bytes"]
                txProc.running = true
            }
        }
    }

    property var addrProc: Process {
        stdout: SplitParser {
            onRead: line => root.ipv4Address = root.parseIpv4(line)
        }
    }

    property var gatewayProc: Process {
        stdout: SplitParser {
            onRead: line => root.gateway = root.parseGateway(line)
        }
    }

    property real _pendingRxBytes: 0
    property real _pendingTxBytes: 0

    property var rxProc: Process {
        stdout: SplitParser {
            onRead: line => root._pendingRxBytes = root.parseNumber(line)
        }
        onExited: {
            if (txProc.running) return
            root.updateRates(root._pendingRxBytes, root._pendingTxBytes)
        }
    }

    property var txProc: Process {
        stdout: SplitParser {
            onRead: line => root._pendingTxBytes = root.parseNumber(line)
        }
        onExited: {
            if (rxProc.running) return
            root.updateRates(root._pendingRxBytes, root._pendingTxBytes)
        }
    }

    property var wifiToggleProc: Process { onExited: root.reload() }

    Component.onCompleted: {
        reload()
        reloadDetails()
    }
}
