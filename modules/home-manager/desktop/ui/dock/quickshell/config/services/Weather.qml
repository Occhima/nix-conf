pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property string temperature: "--°"
    property string description: "Weather"

    function _trim(x) {
        return (x ?? "").toString().trim();
    }

    function update() {
        weather_proc.running = true;
    }

    property var weather_proc: Process {
        command: [
            "sh",
            "-lc",
            "if command -v curl >/dev/null 2>&1; then curl -Lsf 'https://wttr.in/?format=%t|%C' || true; fi"
        ]

        stdout: SplitParser {
            onRead: data => {
                const text = root._trim(data);
                if (!text)
                    return;

                const parts = text.split("|");
                if (parts.length >= 2) {
                    let temp = root._trim(parts[0]);
                    const desc = root._trim(parts[1]);

                    // Strip leading "+" from positive temperatures
                    if (temp.startsWith("+"))
                        temp = temp.substring(1);

                    if (temp)
                        root.temperature = temp;

                    if (desc)
                        root.description = desc;
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
