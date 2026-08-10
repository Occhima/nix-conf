pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real downloadBytesPerSecond: 0
    property real uploadBytesPerSecond: 0
    property real swapUsage: 0
    property real _previousRx: 0
    property real _previousTx: 0
    property double _previousSampleAt: 0

    readonly property string downloadText: formatRate(downloadBytesPerSecond)
    readonly property string uploadText: formatRate(uploadBytesPerSecond)

    function formatRate(bytes): string {
        if (bytes >= 1024 * 1024)
            return (bytes / 1024 / 1024).toFixed(1) + "M"
        return (bytes / 1024).toFixed(1) + "K"
    }

    function parseNetwork(content): void {
        let rx = 0
        let tx = 0
        const lines = content.split("\n")
        for (let index = 2; index < lines.length; index++) {
            const separator = lines[index].indexOf(":")
            if (separator < 0)
                continue
            const name = lines[index].slice(0, separator).trim()
            if (name === "lo")
                continue
            const fields = lines[index].slice(separator + 1).trim().split(/\s+/)
            if (fields.length < 9)
                continue
            rx += parseFloat(fields[0]) || 0
            tx += parseFloat(fields[8]) || 0
        }

        const now = Date.now()
        if (_previousSampleAt > 0) {
            const seconds = Math.max(0.001, (now - _previousSampleAt) / 1000)
            downloadBytesPerSecond = Math.max(0, (rx - _previousRx) / seconds)
            uploadBytesPerSecond = Math.max(0, (tx - _previousTx) / seconds)
        }
        _previousRx = rx
        _previousTx = tx
        _previousSampleAt = now
    }

    function parseSwap(content): void {
        const totalMatch = content.match(/^SwapTotal:\s+(\d+)/m)
        const freeMatch = content.match(/^SwapFree:\s+(\d+)/m)
        if (!totalMatch || !freeMatch)
            return
        const total = parseInt(totalMatch[1], 10)
        const free = parseInt(freeMatch[1], 10)
        swapUsage = total > 0 ? Math.max(0, Math.min(1, (total - free) / total)) : 0
    }

    FileView {
        id: networkFile
        path: "/proc/net/dev"
        onLoaded: root.parseNetwork(text())
    }

    FileView {
        id: memoryFile
        path: "/proc/meminfo"
        onLoaded: root.parseSwap(text())
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            networkFile.reload()
            memoryFile.reload()
        }
    }
}
