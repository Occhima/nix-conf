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
    readonly property var monitor: screen ? Hyprland.monitorFor(screen) : null
    readonly property int wsStart: (monitor?.id ?? 0) * workspacesPerMonitor + 1

    Repeater {
        model: root.workspacesPerMonitor

        Rectangle {
            required property int index

            readonly property int wsId: root.wsStart + index
            readonly property var workspace: {
                for (const ws of Hyprland.workspaces.values)
                    if (ws.id === wsId) return ws
                return null
            }

            readonly property bool active: workspace?.active ?? false
            readonly property bool occupied: (workspace?.toplevels?.values?.length ?? 0) > 0

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
                onClicked: Hyprland.dispatch("workspace " + wsId)
            }
        }
    }
}
