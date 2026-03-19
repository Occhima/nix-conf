import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:/data" as Data

Row {
    id: root

    spacing: 6

    property var screen: null

    readonly property int workspacesPerMonitor: 9

    readonly property int monitorId: {
        if (!screen) return 0
        for (const mon of Hyprland.monitors.values)
            if (mon.name === screen.name) return mon.id
        return 0
    }

    readonly property int wsStart: monitorId * workspacesPerMonitor + 1

    Repeater {
        model: root.workspacesPerMonitor

        Rectangle {
            required property int index

            readonly property int wsId: root.wsStart + index
            readonly property int displayNum: index + 1
            readonly property bool active: Hyprland.focusedMonitor?.id === root.monitorId &&
                                          Hyprland.focusedWorkspace?.id === wsId
            readonly property bool occupied: {
                for (const ws of Hyprland.workspaces.values)
                    if (ws.id === wsId && ws.windows > 0) return true
                return false
            }

            width: active ? 24 : 8
            height: 8
            radius: height / 2
            color: active ? Data.Settings.fgColor : occupied ? Data.Settings.fgDim : Data.Settings.bgLighter

            Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("split:workspace " + displayNum)
            }
        }
    }
}
