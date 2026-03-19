pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import QtQuick

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool powered: adapter?.enabled ?? false
    readonly property int state: adapter?.state ?? BluetoothAdapterState.Disabled

    readonly property var devices: adapter?.devices ?? null

    readonly property BluetoothDevice connectedDevice: {
        if (!adapter || !devices) return null
        // Try ObjectModel pattern (values array)
        const devList = devices.values ?? devices
        const len = devList.length ?? devList.count ?? 0
        for (let i = 0; i < len; i++) {
            const device = devList[i]
            if (device && device.connected) return device
        }
        return null
    }

    readonly property bool connected: connectedDevice !== null

    readonly property string icon: {
        if (state === BluetoothAdapterState.Blocked) return "bluetooth-disabled-symbolic"
        if (!powered) return "bluetooth-disabled-symbolic"
        if (connected) return "bluetooth-active-symbolic"
        return "bluetooth-symbolic"
    }

    readonly property string statusText: {
        if (state === BluetoothAdapterState.Blocked) return "Blocked"
        if (state === BluetoothAdapterState.Enabling) return "Enabling..."
        if (state === BluetoothAdapterState.Disabling) return "Disabling..."
        if (!powered) return "Off"
        if (connected) return connectedDevice.name
        return "Not Connected"
    }

    function toggle() { if (adapter) adapter.enabled = !adapter.enabled }
    function connectDevice(device) { device.connect() }
    function disconnectDevice(device) { device.disconnect() }
    function startDiscovery() { if (adapter) adapter.discovering = true }
    function stopDiscovery() { if (adapter) adapter.discovering = false }
}
