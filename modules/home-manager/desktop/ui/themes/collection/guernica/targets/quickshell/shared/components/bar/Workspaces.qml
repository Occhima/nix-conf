import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.WindowManager
import "root:/data" as Data

Row {
    id: root

    spacing: 6

    property var screen: null

    readonly property int workspacesPerMonitor: 9
    readonly property bool usingNiri: Boolean(Quickshell.env("NIRI_SOCKET"))
    readonly property var monitor: screen ? Hyprland.monitorFor(screen) : null
    readonly property var niriProjection: usingNiri && screen
        ? WindowManager.screenProjection(screen)
        : null

    readonly property var monitorWorkspaces: {
        if (usingNiri) {
            const arr = niriProjection
                ? [...niriProjection.windowsets].filter(ws => ws.shouldDisplay)
                : []
            arr.sort((a, b) => (a.coordinates[1] ?? 0) - (b.coordinates[1] ?? 0))
            return arr
        }
        if (!monitor) return []
        const arr = []
        for (const ws of Hyprland.workspaces.values)
            if (ws.monitor?.name === monitor.name) arr.push(ws)
        arr.sort((a, b) => a.id - b.id)
        return arr
    }

    Repeater {
        model: root.usingNiri ? root.monitorWorkspaces.length : root.workspacesPerMonitor

        Rectangle {
            required property int index

            readonly property int slot: index + 1
            readonly property var workspace: root.monitorWorkspaces[index] ?? null

            readonly property bool active: workspace?.active ?? false
            readonly property bool occupied: root.usingNiri
                ? index < root.monitorWorkspaces.length - 1
                : (workspace?.toplevels?.values?.length ?? 0) > 0

            width: active ? 18 : 6
            height: 6
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
                onClicked: {
                    if (root.usingNiri) {
                        if (workspace?.canActivate) workspace.activate()
                    } else {
                        Hyprland.dispatch("split-workspace " + slot)
                    }
                }
            }
        }
    }
}
