import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.WindowManager

import "root:/data" as Data

Row {
    id: root

    required property var screen

    spacing: 5

    readonly property bool usingNiri: Boolean(Quickshell.env("NIRI_SOCKET"))
    readonly property var monitor: screen ? Hyprland.monitorFor(screen) : null
    readonly property var niriProjection: usingNiri && screen
        ? WindowManager.screenProjection(screen)
        : null
    readonly property var workspaces: {
        if (usingNiri) {
            const result = niriProjection
                ? [...niriProjection.windowsets].filter(workspace => workspace.shouldDisplay)
                : []
            result.sort((left, right) => (left.coordinates[1] ?? 0) - (right.coordinates[1] ?? 0))
            return result
        }

        if (!monitor)
            return []

        const result = []
        for (const workspace of Hyprland.workspaces.values) {
            if (workspace.monitor?.name === monitor.name)
                result.push(workspace)
        }
        result.sort((left, right) => left.id - right.id)
        return result
    }

    Repeater {
        model: root.usingNiri ? Math.max(1, root.workspaces.length) : 5

        Rectangle {
            required property int index

            readonly property var workspace: root.workspaces[index] ?? null
            readonly property bool active: workspace?.active ?? false
            readonly property bool occupied: root.usingNiri
                ? workspace !== null
                : (workspace?.toplevels?.values?.length ?? 0) > 0

            anchors.verticalCenter: parent.verticalCenter
            width: active ? 17 : 5
            height: 4
            radius: 2
            color: active
                ? Data.Settings.fgColor
                : occupied
                    ? Data.Settings.fgDim
                    : Data.Settings.bgLighter

            Behavior on width {
                NumberAnimation {
                    duration: Data.Settings.animShort
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation { duration: Data.Settings.animShort }
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.usingNiri) {
                        if (parent.workspace?.canActivate)
                            parent.workspace.activate()
                    } else {
                        Hyprland.dispatch("split-workspace " + (parent.index + 1))
                    }
                }
            }
        }
    }
}
