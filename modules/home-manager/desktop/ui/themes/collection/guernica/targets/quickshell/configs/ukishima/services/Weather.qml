pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "root:/data" as Data

Singleton {
    id: root

    property string temperature: "--°"
    property string description: "Weather"

    function update(): void {
        request.running = true
    }

    Process {
        id: request
        command: ["curl", "-Lsf", "https://wttr.in/?format=%t|%C"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = Data.Utils.trim(text).split("|")
                if (parts.length < 2) return

                const temperature = Data.Utils.trim(parts[0]).replace(/^\+/, "")
                const description = Data.Utils.trim(parts[1])
                if (temperature) root.temperature = temperature
                if (description) root.description = description
            }
        }
    }

    Timer {
        interval: 1800000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }
}
