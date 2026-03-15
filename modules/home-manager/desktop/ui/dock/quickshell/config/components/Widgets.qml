import QtQuick
import QtQuick.Controls

import "../data" as Data
import "../services" as Services

Column {
    spacing: 6

    Repeater {
        model: [
            {
                icon: Services.Notifications.dnd ? "󰂛" : "󰂚",
                tip: Services.Notifications.dnd ? "DND: enabled" : "DND: disabled",
                onPress: function() { Services.Notifications.toggleDnd(); }
            },
            {
                icon: Services.Pipewire.muted ? "󰝟" : "󰕾",
                tip: Services.Pipewire.muted ? "Audio: muted" : "Audio: unmuted",
                onPress: function() { Services.Pipewire.toggleMute(); }
            },
            {
                icon: "󰑐",
                tip: "Refresh system stats",
                onPress: function() { Services.SystemUsage.refresh(); }
            }
        ]

        delegate: Rectangle {
            width: 24
            height: 24
            radius: 12
            color: mouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight
            border.width: 1
            border.color: Data.Settings.fgColor
            opacity: mouse.containsMouse ? 0.95 : 0.85

            Text {
                anchors.centerIn: parent
                text: modelData.icon
                color: Data.Settings.fgColor
                font.pixelSize: 13
                opacity: 0.95
            }

            ToolTip.visible: mouse.containsMouse
            ToolTip.text: modelData.tip

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: modelData.onPress()
                cursorShape: Qt.PointingHandCursor
            }
        }
    }

    Rectangle {
        width: 24
        height: 4
        radius: 2
        color: Data.Settings.bgLighter

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, Services.SystemUsage.cpuUsage / 100))
            height: parent.height
            radius: parent.radius
            color: Data.Settings.accentColor
        }

        ToolTip.visible: cpuHover.containsMouse
        ToolTip.text: "CPU: " + Math.round(Services.SystemUsage.cpuUsage) + "%"

        MouseArea {
            id: cpuHover
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    Rectangle {
        width: 24
        height: 4
        radius: 2
        color: Data.Settings.bgLighter

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, Services.SystemUsage.ramUsage / 100))
            height: parent.height
            radius: parent.radius
            color: Data.Settings.purpleColor
        }

        ToolTip.visible: ramHover.containsMouse
        ToolTip.text: "RAM: " + Math.round(Services.SystemUsage.ramUsage) + "%"

        MouseArea {
            id: ramHover
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
