import QtQuick
import QtQuick.Layouts

import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            Gauge {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "CPU"
                value: Services.SystemUsage.cpuUsage
                primary: Math.round(value * 100) + "%"
                secondary: Services.SystemUsage.cpuTemp > 0
                    ? Math.round(Services.SystemUsage.cpuTemp) + "°"
                    : "LIVE"
                accent: Data.Settings.warmAccent
            }

            Gauge {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "MEM"
                value: Services.SystemUsage.memUsage
                primary: Services.SystemUsage.memUsedGiB.toFixed(1)
                secondary: "/ " + Services.SystemUsage.memTotalGiB.toFixed(0) + " GB"
                accent: Data.Settings.warmAccent
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Data.Settings.hairline
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            spacing: 0

            Metric {
                Layout.fillWidth: true
                label: "NET"
                value: "↓" + Services.SystemMetrics.downloadText
                    + " ↑" + Services.SystemMetrics.uploadText
                accent: Data.Settings.warmAccent
            }
            Divider {}
            Metric {
                Layout.fillWidth: true
                label: "DISK"
                value: Math.round(Services.SystemUsage.diskUsage * 100) + "%"
                accent: Data.Settings.warmAccent
            }
            Divider {}
            Metric {
                Layout.fillWidth: true
                label: "SWAP"
                value: Math.round(Services.SystemMetrics.swapUsage * 100) + "%"
                accent: Data.Settings.fgColor
            }
            Divider {}
            Metric {
                Layout.fillWidth: true
                label: "GPU"
                value: Math.round(Services.SystemUsage.gpuUsage * 100) + "%"
                accent: Data.Settings.warmAccent
            }
        }
    }

    component Gauge: Item {
        id: gauge

        required property string label
        required property real value
        required property string primary
        required property string secondary
        required property color accent

        onValueChanged: ring.requestPaint()
        onAccentChanged: ring.requestPaint()

        Canvas {
            id: ring

            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height * 1.35)
            height: Math.min(parent.height, width * 0.78)

            onPaint: {
                const context = getContext("2d")
                const centerX = width / 2
                const centerY = height * 0.57
                const radius = Math.min(width * 0.37, height * 0.48)
                const start = Math.PI * 0.76
                const sweep = Math.PI * 1.48

                context.reset()
                context.lineWidth = 6
                context.lineCap = "round"
                context.beginPath()
                context.strokeStyle = Data.Settings.bgLighter
                context.arc(centerX, centerY, radius, start, start + sweep)
                context.stroke()

                context.beginPath()
                context.strokeStyle = gauge.accent
                context.arc(
                    centerX,
                    centerY,
                    radius,
                    start,
                    start + sweep * Math.max(0, Math.min(1, gauge.value))
                )
                context.stroke()
            }
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 3
            spacing: 0

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: gauge.primary
                color: Data.Settings.fgColor
                font.family: "monospace"
                font.pixelSize: Data.Settings.fontLg
                font.weight: Font.Bold
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: gauge.label
                color: Data.Settings.fgDim
                font.family: "monospace"
                font.pixelSize: Data.Settings.fontXs
                font.letterSpacing: 1
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: gauge.secondary
                color: Data.Settings.fgDim
                font.family: "monospace"
                font.pixelSize: Data.Settings.fontXs
            }
        }
    }

    component Metric: ColumnLayout {
        required property string label
        required property string value
        required property color accent

        spacing: 1

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: label
            color: Data.Settings.fgDim
            font.family: "monospace"
            font.pixelSize: Data.Settings.fontXs
            font.letterSpacing: 1
        }
        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: value
            color: accent
            font.family: "monospace"
            font.pixelSize: Data.Settings.fontXs
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }
    }

    component Divider: Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 24
        color: Data.Settings.hairline
    }
}
