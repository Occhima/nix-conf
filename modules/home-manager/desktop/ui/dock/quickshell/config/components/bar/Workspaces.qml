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
            readonly property string displayNumText: String(displayNum)
            readonly property bool active: {
                if (Hyprland.focusedMonitor?.id !== root.monitorId) return false

                const focused = Hyprland.focusedWorkspace
                if (!focused) return false
                if (focused.id === wsId || focused.id === displayNum) return true

                const focusedName = String(focused.name ?? focused.lastIpcObject?.name ?? "")
                return focusedName === displayNumText || focusedName.startsWith(displayNumText + ":")
            }
            readonly property bool occupied: {
                for (const ws of Hyprland.workspaces.values) {
                    const windows = ws.windows ?? ws.lastIpcObject?.windows ?? 0
                    const wsName = String(ws.name ?? ws.lastIpcObject?.name ?? "")
                    const matches = ws.id === wsId ||
                                    ws.id === displayNum ||
                                    wsName === String(wsId) ||
                                    wsName === displayNumText ||
                                    wsName.startsWith(displayNumText + ":")
                    if (matches && windows > 0) return true
                }
                return false
            }

            width: active ? 24 : 10
            height: 10
            radius: 3
            color: active
                   ? Data.Settings.fgColor
                   : occupied
                     ? Data.Settings.accentColor
                     : Data.Settings.bgLighter

            Behavior on width { NumberAnimation { duration: Data.Settings.animShort; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("split:workspace " + displayNum)
            }
        }
    }
}
