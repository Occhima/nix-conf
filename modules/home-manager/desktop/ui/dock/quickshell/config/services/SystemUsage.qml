pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property real cpuUsage: 0
    property real memUsage: 0
    property real diskUsage: 0

    // CPU calculation state
    property real _prevIdle: 0
    property real _prevTotal: 0

    property var cpuProc: Process {
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("cpu ")) {
                    const parts = data.split(/\s+/).slice(1).map(Number);
                    const idle = parts[3] + parts[4];
                    const total = parts.reduce((a, b) => a + b, 0);

                    if (root._prevTotal > 0) {
                        const idleDelta = idle - root._prevIdle;
                        const totalDelta = total - root._prevTotal;
                        root.cpuUsage = totalDelta > 0 ? 1 - (idleDelta / totalDelta) : 0;
                    }
                    root._prevIdle = idle;
                    root._prevTotal = total;
                }
            }
        }
    }

    property var memProc: Process {
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split(/\s+/).filter(p => p.length > 0);
                if (parts.length >= 3) {
                    const total = parseFloat(parts[1]);
                    const used = parseFloat(parts[2]);
                    root.memUsage = total > 0 ? used / total : 0;
                }
            }
        }
    }

    property var diskProc: Process {
        command: ["sh", "-c", "df / | tail -1"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split(/\s+/).filter(p => p.length > 0);
                if (parts.length >= 5) {
                    const pct = parts[4].replace('%', '');
                    root.diskUsage = parseFloat(pct) / 100;
                }
            }
        }
    }

    property var updateTimer: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
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
