pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import "root:/data" as Data

QtObject {
    id: root

    property string temperature: "--\u00b0"
    property string description: "Weather"

    function update() {
        weatherProc.running = true
    }

    property var weatherProc: Process {
        command: [
            "sh",
            "-lc",
            "if command -v curl >/dev/null 2>&1; then curl -Lsf 'https://wttr.in/?format=%t|%C' || true; fi"
        ]

        stdout: SplitParser {
            onRead: data => {
                const text = Data.Utils.trim(data)
                if (!text)
                    return

                const parts = text.split("|")
                if (parts.length >= 2) {
                    let temp = Data.Utils.trim(parts[0])
                    const desc = Data.Utils.trim(parts[1])

                    if (temp.startsWith("+"))
                        temp = temp.substring(1)

                    if (temp)
                        root.temperature = temp

                    if (desc)
                        root.description = desc
                }
            }
        }
    }

    property var updateTimer: Timer {
        interval: 1800000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }
}
