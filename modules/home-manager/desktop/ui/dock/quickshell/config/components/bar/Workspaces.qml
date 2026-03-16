import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:/data" as Data

Row {
    id: workspacesRow
    spacing: 6

    // Screen/monitor this bar is on - set by parent
    property var screen: null

    // Number of workspaces per monitor (hyprsplit config)
    readonly property int workspacesPerMonitor: 9

    // Get the monitor ID for this screen
    readonly property int monitorId: {
        if (!screen) return 0;
        // Find matching Hyprland monitor
        for (const mon of Hyprland.monitors.values) {
            if (mon.name === screen.name) {
                return mon.id;
            }
        }
        return 0;
    }

    // Calculate workspace range for this monitor
    readonly property int wsStart: monitorId * workspacesPerMonitor + 1
    readonly property int wsEnd: wsStart + workspacesPerMonitor - 1

    Repeater {
        model: workspacesRow.workspacesPerMonitor

        Rectangle {
            required property int index
            readonly property int wsId: workspacesRow.wsStart + index
            readonly property int displayNum: index + 1

            readonly property bool active: Hyprland.focusedMonitor?.id === workspacesRow.monitorId &&
                                          Hyprland.focusedWorkspace?.id === wsId
            readonly property bool occupied: {
                for (const ws of Hyprland.workspaces.values) {
                    if (ws.id === wsId && ws.windows > 0) return true
                }
                return false
            }

            width: active ? 24 : 8
            height: 8
            radius: height / 2
            color: active ? Data.Settings.fgColor
                 : occupied ? Data.Settings.fgDim
                 : Data.Settings.bgLighter

            Behavior on width {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("split:workspace " + displayNum)
            }
        }
    }
}
