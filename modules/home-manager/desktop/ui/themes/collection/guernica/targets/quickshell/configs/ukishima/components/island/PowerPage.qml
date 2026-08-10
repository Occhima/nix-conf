import QtQuick
import Quickshell

import "root:/data" as Data

Item {
    id: root

    property int hoveredIndex: -1

    readonly property var actions: [
        {
            label: "Lock",
            icon: "system-lock-screen-symbolic",
            confirm: false,
            command: ["qs-lock"]
        },
        {
            label: "Log out",
            icon: "system-log-out-symbolic",
            confirm: true,
            command: ["qs-logout"]
        },
        {
            label: "Sleep",
            icon: "weather-clear-night-symbolic",
            confirm: false,
            command: ["systemctl", "suspend"]
        },
        {
            label: "Restart",
            icon: "system-reboot-symbolic",
            confirm: true,
            command: ["systemctl", "reboot"]
        },
        {
            label: "Shutdown",
            icon: "system-shutdown-symbolic",
            confirm: true,
            command: ["systemctl", "poweroff"]
        }
    ]

    function run(action): void {
        Data.Runtime.closeAll()
        Quickshell.execDetached(action.command)
    }

    Row {
        id: tiles

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        spacing: 8

        Repeater {
            model: root.actions

            delegate: Row {
                id: cell

                required property int index
                required property var modelData
                spacing: 8

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: cell.index === 3
                    width: visible ? 1 : 0
                    height: 26
                    color: Data.Settings.hairline
                }

                Rectangle {
                    id: tile

                    width: 46
                    height: 46
                    radius: 13
                    color: tileMouse.containsMouse
                        ? Data.Settings.bgLighter
                        : "transparent"
                    border.width: 1
                    border.color: tileMouse.containsMouse
                        ? (cell.modelData.confirm
                            ? Qt.alpha(Data.Settings.errorColor, 0.42)
                            : Data.Settings.borderHover)
                        : Data.Settings.borderSubtle

                    Behavior on color {
                        ColorAnimation { duration: Data.Settings.animFast }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: tileMouse.pressed && cell.modelData.confirm
                            ? parent.height
                            : 0
                        radius: parent.radius
                        color: Qt.alpha(Data.Settings.errorColor, 0.16)

                        Behavior on height {
                            NumberAnimation {
                                duration: tileMouse.pressed ? 900 : 180
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Image {
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                        sourceSize: Qt.size(width, height)
                        source: Quickshell.iconPath(cell.modelData.icon)
                        opacity: tileMouse.containsMouse ? 1 : 0.68
                    }

                    MouseArea {
                        id: tileMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        pressAndHoldInterval: 900
                        onContainsMouseChanged: {
                            if (containsMouse) root.hoveredIndex = cell.index
                            else if (root.hoveredIndex === cell.index) root.hoveredIndex = -1
                        }
                        onClicked: {
                            if (!cell.modelData.confirm) root.run(cell.modelData)
                        }
                        onPressAndHold: {
                            if (cell.modelData.confirm) root.run(cell.modelData)
                        }
                    }
                }
            }
        }
    }

    Text {
        anchors.top: tiles.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.hoveredIndex < 0
            ? ""
            : root.actions[root.hoveredIndex].label
                + (root.actions[root.hoveredIndex].confirm ? " — hold" : "")
        color: root.hoveredIndex >= 0 && root.actions[root.hoveredIndex].confirm
            ? Data.Settings.errorColor
            : Data.Settings.fgDim
        font.pixelSize: Data.Settings.fontSm
        font.weight: Font.Medium
    }
}
