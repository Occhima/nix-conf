pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import "root:/data" as Data

QtObject {
    id: root

    property string osPrettyName: "Linux"
    property string wm: "Wayland"
    property string uptime: "..."
    property string user: Quickshell.env("USER") || "user"
    property string home: Quickshell.env("HOME") || ""

    property string facePath: ""

    property var faceCheckProc: Process {
        command: ["bash", "-c", "[ -f '" + root.home + "/.face' ] && echo exists || true"]
        running: root.home !== ""
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "exists")
                    root.facePath = "file://" + root.home + "/.face"
            }
        }
    }

    function update() {
        osRelease.reload()
        detectWm()
        uptimeProc.running = true
    }

    function detectWm() {
        if (Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")) {
            root.wm = "Hyprland"
        } else if (Quickshell.env("NIRI_SOCKET")) {
            root.wm = "Niri"
        } else {
            root.wm = "Wayland"
        }
    }

    property var osRelease: FileView {
        path: "/etc/os-release"
        onLoaded: {
            const content = text()
            const lines = content.split("\n")
            for (const line of lines) {
                if (line.startsWith("PRETTY_NAME=")) {
                    let value = line.substring(12)
                    value = value.replace(/^["']|["']$/g, "")
                    if (value) root.osPrettyName = value
                    break
                }
            }
        }
    }

    property var uptimeProc: Process {
        command: ["sh", "-lc", "uptime -p 2>/dev/null | sed 's/^up //'"]

        stdout: SplitParser {
            onRead: data => {
                const v = Data.Utils.trim(data)
                if (v)
                    root.uptime = v
            }
        }
    }

    property var updateTimer: Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }
}
