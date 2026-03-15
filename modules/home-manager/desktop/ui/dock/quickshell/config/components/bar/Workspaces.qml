import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:/data" as Data

Row {
    spacing: 6

    Repeater {
        model: {
            const wsList = []
            for (let i = 1; i <= 5; i++) {
                wsList.push(i)
            }
            return wsList
        }

        Rectangle {
            required property int modelData
            readonly property bool active: Hyprland.focusedWorkspace?.id === modelData
            readonly property bool occupied: {
                for (const ws of Hyprland.workspaces.values) {
                    if (ws.id === modelData && ws.windows > 0) return true
                }
                return false
            }

            width: active ? 24 : 8
            height: 8
            radius: height / 2
            color: active ? Data.Settings.accentColor
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
                onClicked: Hyprland.dispatch("workspace " + modelData)
            }
        }
    }
}
