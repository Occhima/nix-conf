pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property real cpuUsage: 0
    property real memUsage: 0
    property real diskUsage: 0
    property real cpuTemp: 0
    property real gpuTemp: 0
    property real gpuUsage: 0
    property real memUsedGiB: 0
    property real memTotalGiB: 0

    property real _prevIdle: 0
    property real _prevTotal: 0

    property var cpuStat: FileView {
        path: "/proc/stat"
        onLoaded: {
            const content = text()
            const lines = content.split("\n")
            for (const line of lines) {
                if (!line.startsWith("cpu ")) continue
                const parts = line.split(/\s+/).slice(1).map(Number)
                const idle = parts[3] + parts[4]
                const total = parts.reduce((a, b) => a + b, 0)

                if (root._prevTotal > 0) {
                    const idleDelta = idle - root._prevIdle
                    const totalDelta = total - root._prevTotal
                    root.cpuUsage = totalDelta > 0 ? 1 - (idleDelta / totalDelta) : 0
                }
                root._prevIdle = idle
                root._prevTotal = total
                break
            }
        }
    }

    property var cpuTempFile: FileView {
        path: "/sys/class/thermal/thermal_zone0/temp"
        onLoaded: {
            const content = text()
            const val = parseFloat(content.trim())
            if (!isNaN(val)) root.cpuTemp = val > 200 ? val / 1000 : val
        }
    }

    property var memInfo: FileView {
        path: "/proc/meminfo"
        onLoaded: {
            const content = text()
            let total = 0
            let available = 0
            const lines = content.split("\n")
            for (const line of lines) {
                if (line.startsWith("MemTotal:")) {
                    total = parseFloat(line.split(/\s+/)[1])
                } else if (line.startsWith("MemAvailable:")) {
                    available = parseFloat(line.split(/\s+/)[1])
                }
            }
            if (total > 0) {
                const used = total - available
                root.memUsage = used / total
                root.memUsedGiB = used / 1024 / 1024
                root.memTotalGiB = total / 1024 / 1024
            }
        }
    }

    property var gpuInfoProc: Process {
        command: ["sh", "-c", "if command -v nvidia-smi >/dev/null 2>&1; then nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | head -1; else echo '0,0'; fi"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split(",")
                if (parts.length < 2) return
                const usage = parseFloat(parts[0].trim())
                const temp = parseFloat(parts[1].trim())
                root.gpuUsage = isNaN(usage) ? 0 : usage / 100
                root.gpuTemp = isNaN(temp) ? 0 : temp
            }
        }
    }

    property var diskProc: Process {
        command: ["sh", "-c", "df / | tail -1"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split(/\s+/).filter(p => p.length > 0)
                if (parts.length >= 5) root.diskUsage = parseFloat(parts[4].replace('%', '')) / 100
            }
        }
    }

    property var updateTimer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuStat.reload()
            memInfo.reload()
            cpuTempFile.reload()
            gpuInfoProc.running = true
        }
    }

    property var diskTimer: Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: diskProc.running = true
    }
}
