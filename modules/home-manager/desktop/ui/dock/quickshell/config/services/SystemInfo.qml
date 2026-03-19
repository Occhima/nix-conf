pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property string osPrettyName: "Linux"
    property string wm: "Wayland"
    property string uptime: "..."
    property string user: "user"
    property string home: ""

    readonly property string facePath: home ? "file://" + home + "/.face" : ""

    function _trim(x) {
        return (x ?? "").toString().trim();
    }

    function update() {
        os_proc.running = true;
        wm_proc.running = true;
        uptime_proc.running = true;
        user_proc.running = true;
        home_proc.running = true;
    }

    property var os_proc: Process {
        command: ["sh", "-lc", "grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '\"'"]

        stdout: SplitParser {
            onRead: data => {
                const v = root._trim(data);
                if (v)
                    root.osPrettyName = v;
            }
        }
    }

    property var wm_proc: Process {
        command: [
            "sh",
            "-lc",
            "if [ -n \"$HYPRLAND_INSTANCE_SIGNATURE\" ]; then echo Hyprland; elif [ -n \"$NIRI_SOCKET\" ]; then echo Niri; else echo Wayland; fi"
        ]

        stdout: SplitParser {
            onRead: data => {
                const v = root._trim(data);
                if (v)
                    root.wm = v;
            }
        }
    }

    property var uptime_proc: Process {
        command: ["sh", "-lc", "uptime -p 2>/dev/null | sed 's/^up //'"]

        stdout: SplitParser {
            onRead: data => {
                const v = root._trim(data);
                if (v)
                    root.uptime = v;
            }
        }
    }

    property var user_proc: Process {
        command: ["sh", "-lc", "id -un"]

        stdout: SplitParser {
            onRead: data => {
                const v = root._trim(data);
                if (v)
                    root.user = v;
            }
        }
    }

    property var home_proc: Process {
        command: ["sh", "-lc", "printf %s \"$HOME\""]

        stdout: SplitParser {
            onRead: data => {
                const v = root._trim(data);
                if (v)
                    root.home = v;
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
