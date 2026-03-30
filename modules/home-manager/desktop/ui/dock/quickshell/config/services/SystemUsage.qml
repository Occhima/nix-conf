pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property string gpuType: "NONE"

    property real cpuUsage: 0
    property real cpuTemp: 0
    property real gpuUsage: 0
    property real gpuTemp: 0

    property real memUsage: 0
    property real memUsedGiB: 0
    property real memTotalGiB: 0

    property real diskUsage: 0
    property real diskUsedGiB: 0
    property real diskTotalGiB: 0

    property real _prevCpuIdle: 0
    property real _prevCpuTotal: 0

    readonly property bool hasGpu: gpuType !== "NONE"

    function safeNumber(value, fallback) {
        const num = parseFloat(String(value).trim())
        return isNaN(num) ? fallback : num
    }

    function clamp01(value) {
        return Math.max(0, Math.min(1, value))
    }

    function toGiBFromKiB(valueKiB) {
        return valueKiB / 1024 / 1024
    }

    function setCpuSample(idle, total) {
        if (root._prevCpuTotal > 0) {
            const idleDelta = idle - root._prevCpuIdle
            const totalDelta = total - root._prevCpuTotal
            root.cpuUsage = totalDelta > 0
                ? root.clamp01(1 - (idleDelta / totalDelta))
                : 0
        }

        root._prevCpuIdle = idle
        root._prevCpuTotal = total
    }

    function parseCpuStat(content) {
        const match = content.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/m)
        if (!match)
            return

        const values = match.slice(1).map(v => parseInt(v, 10))
        const total = values.reduce((acc, v) => acc + v, 0)
        const idle = values[3] + values[4]
        root.setCpuSample(idle, total)
    }

    function parseMemInfo(content) {
        const totalMatch = content.match(/^MemTotal:\s+(\d+)/m)
        const availableMatch = content.match(/^MemAvailable:\s+(\d+)/m)
        if (!totalMatch || !availableMatch)
            return

        const totalKiB = parseInt(totalMatch[1], 10)
        const availableKiB = parseInt(availableMatch[1], 10)
        const usedKiB = totalKiB - availableKiB
        if (totalKiB <= 0)
            return

        root.memUsage = root.clamp01(usedKiB / totalKiB)
        root.memUsedGiB = root.toGiBFromKiB(usedKiB)
        root.memTotalGiB = root.toGiBFromKiB(totalKiB)
    }

    function parseDiskDf(content) {
        const line = content.trim().split("\n").pop()
        if (!line)
            return

        const parts = line.split(/\s+/)
        if (parts.length < 5)
            return

        const totalKiB = root.safeNumber(parts[1], 0)
        const usedKiB = root.safeNumber(parts[2], 0)
        const usedPct = root.safeNumber(parts[4].replace("%", ""), 0)
        if (totalKiB <= 0)
            return

        root.diskUsage = root.clamp01(usedPct / 100)
        root.diskUsedGiB = root.toGiBFromKiB(usedKiB)
        root.diskTotalGiB = root.toGiBFromKiB(totalKiB)
    }

    function parseSensorOutput(content) {
        const raw = content.trim()
        if (!raw.length)
            return

        if (/^\d+$/.test(raw)) {
            const value = root.safeNumber(raw, 0)
            root.cpuTemp = value > 200 ? value / 1000 : value
            return
        }

        const cpuMatch =
            raw.match(/(?:Package id \d+|Tctl|Tdie):\s*\+?([0-9.]+)/i)
            || raw.match(/temp1:\s*\+?([0-9.]+)/i)
        if (cpuMatch)
            root.cpuTemp = root.safeNumber(cpuMatch[1], root.cpuTemp)

        if (root.gpuType !== "GENERIC")
            return

        const gpuMatch =
            raw.match(/(?:edge|junction|GPU core):\s*\+?([0-9.]+)/i)
            || raw.match(/temp\d+:\s*\+?([0-9.]+)/i)
        if (gpuMatch)
            root.gpuTemp = root.safeNumber(gpuMatch[1], root.gpuTemp)
    }

    function parseNvidiaSample(content) {
        const line = content.trim().split("\n")[0]
        if (!line)
            return

        const parts = line.split(",")
        if (parts.length < 2)
            return

        const usage = root.safeNumber(parts[0], 0)
        const temp = root.safeNumber(parts[1], 0)
        root.gpuUsage = root.clamp01(usage / 100)
        root.gpuTemp = temp
    }

    function parseGenericGpuUsage(content) {
        const values = content
            .trim()
            .split("\n")
            .map(v => root.safeNumber(v, NaN))
            .filter(v => !isNaN(v))

        if (!values.length) {
            root.gpuUsage = 0
            return
        }

        const avg = values.reduce((acc, v) => acc + v, 0) / values.length
        root.gpuUsage = root.clamp01(avg / 100)
    }

    property var gpuBackendDetect: Process {
        running: true
        command: [
            "sh",
            "-lc",
            "if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -L >/dev/null 2>&1; then echo NVIDIA; elif ls /sys/class/drm/card*/device/gpu_busy_percent >/dev/null 2>&1; then echo GENERIC; else echo NONE; fi"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const backend = text.trim().toUpperCase()
                root.gpuType = backend.length ? backend : "NONE"
            }
        }
    }

    property var cpuStat: FileView {
        path: "/proc/stat"
        onLoaded: root.parseCpuStat(text())
    }

    property var memInfo: FileView {
        path: "/proc/meminfo"
        onLoaded: root.parseMemInfo(text())
    }

    property var diskProc: Process {
        command: ["sh", "-lc", "df -k / | tail -1"]

        stdout: StdioCollector {
            onStreamFinished: root.parseDiskDf(text)
        }
    }

    property var gpuUsageProc: Process {
        command: root.gpuType === "NVIDIA"
            ? [
                "nvidia-smi",
                "--query-gpu=utilization.gpu,temperature.gpu",
                "--format=csv,noheader,nounits"
            ]
            : root.gpuType === "GENERIC"
                ? ["sh", "-lc", "cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null"]
                : ["sh", "-lc", "printf '0,0\\n'"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (root.gpuType === "NVIDIA") {
                    root.parseNvidiaSample(text)
                    return
                }

                if (root.gpuType === "GENERIC") {
                    root.parseGenericGpuUsage(text)
                    return
                }

                root.gpuUsage = 0
                root.gpuTemp = 0
            }
        }
    }

    property var sensorProc: Process {
        command: [
            "sh",
            "-lc",
            "sensors 2>/dev/null || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null"
        ]

        stdout: StdioCollector {
            onStreamFinished: root.parseSensorOutput(text)
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
            gpuUsageProc.running = true
            sensorProc.running = true
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
