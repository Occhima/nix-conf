pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var entries: []
    property bool available: false
    property bool probeComplete: false
    readonly property alias model: entryModel

    function refresh(): void {
        if (root.available && !history.running)
            history.running = true
    }

    function copy(entry): void {
        if (!root.available || !entry || copyProcess.running)
            return

        copyProcess.command = [
            "sh",
            "-c",
            "cliphist decode \"$1\" | wl-copy",
            "sh",
            String(entry.id)
        ]
        copyProcess.running = true
    }

    Process {
        id: availabilityProbe
        command: [
            "sh",
            "-c",
            "command -v cliphist >/dev/null 2>&1 && command -v wl-copy >/dev/null 2>&1 && printf ready"
        ]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.available = text.trim() === "ready"
                root.probeComplete = true
                if (root.available)
                    root.refresh()
            }
        }
    }

    Process {
        id: history
        command: ["cliphist", "list"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.entries = text
                    .split("\n")
                    .filter(line => line.length > 0)
                    .map(line => {
                        const separator = line.indexOf("\t")
                        const id = separator < 0 ? line : line.slice(0, separator)
                        const raw = separator < 0 ? line : line.slice(separator + 1)
                        return {
                            id: id,
                            text: raw.replace(/\s+/g, " ").trim()
                        }
                    })
            }
        }
    }

    Process { id: copyProcess }

    ScriptModel {
        id: entryModel
        values: root.entries
    }

    Timer {
        interval: 3000
        running: root.available
        repeat: true
        triggeredOnStart: false
        onTriggered: root.refresh()
    }
}
