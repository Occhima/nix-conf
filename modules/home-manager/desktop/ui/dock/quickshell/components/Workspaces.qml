import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../data" as Data

Column {
    spacing: 4

    Repeater {
        model: {
            const wsList = [];
            for (let i = 1; i <= 5; i++) {
                wsList.push(i);
            }
            return wsList;
        }

        Rectangle {
            required property int modelData
            readonly property bool active: Hyprland.focusedWorkspace?.id === modelData
            readonly property bool occupied: {
                for (const ws of Hyprland.workspaces.values) {
                    if (ws.id === modelData && ws.windows > 0) return true;
                }
                return false;
            }

            width: 8
            height: active ? 20 : 8
            radius: width / 2
            color: active ? Data.Settings.accentColor
                 : occupied ? Data.Settings.fgDim
                 : Data.Settings.bgLighter

            Behavior on height {
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
