pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "root:/data" as Data

Singleton {
    id: root

    property string osPrettyName: "Linux"
    property string wm: "Wayland"
    property string uptime: "..."

    readonly property string user: Quickshell.env("USER") || "user"
    readonly property string home: Quickshell.env("HOME") || ""
    readonly property string facePath: home ? "file://" + home + "/.face" : ""

    function update(): void {
        osRelease.reload()
        uptimeProcess.running = true
    }

    function detectWm(): void {
        if (Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE"))
            wm = "Hyprland"
        else if (Quickshell.env("NIRI_SOCKET"))
            wm = "Niri"
        else
            wm = "Wayland"
    }

    FileView {
        id: osRelease
        path: "/etc/os-release"
        onLoaded: {
            const match = text().match(/^PRETTY_NAME=(.*)$/m)
            if (match)
                root.osPrettyName = match[1].replace(/^["']|["']$/g, "") || "Linux"
        }
    }

    Process {
        id: uptimeProcess
        command: ["uptime", "-p"]
        stdout: StdioCollector {
            onStreamFinished: {
                const value = Data.Utils.trim(text).replace(/^up\s+/, "")
                if (value)
                    root.uptime = value
            }
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }

    Component.onCompleted: detectWm()
}
