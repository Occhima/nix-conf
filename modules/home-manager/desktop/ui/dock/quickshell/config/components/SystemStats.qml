import QtQuick
import QtQuick.Controls
import "../data" as Data
import "../services" as Services

Column {
    id: root
    spacing: 5

    Repeater {
        model: [
            { icon: "󰘚", value: Services.SystemUsage.wifiText, tip: "Wi-Fi" },
            { icon: "󰂯", value: Services.SystemUsage.bluetoothText, tip: "Bluetooth" },
            { icon: "󰍛", value: Math.round(Services.SystemUsage.cpuUsage) + "%", tip: "CPU" },
            { icon: "󰾆", value: Math.round(Services.SystemUsage.ramUsage) + "%", tip: "RAM" },
            { icon: "󰢮", value: Services.SystemUsage.gpuText, tip: "GPU" },
            { icon: "󰋊", value: Services.SystemUsage.diskText, tip: "Disk /" }
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
                opacity: 0.95
                font.pixelSize: 13
            }

            ToolTip.visible: mouse.containsMouse
            ToolTip.text: modelData.tip + ": " + modelData.value

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}
