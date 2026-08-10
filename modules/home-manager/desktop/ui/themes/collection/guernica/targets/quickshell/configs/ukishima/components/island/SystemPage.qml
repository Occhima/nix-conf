import QtQuick
import QtQuick.Layouts

import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingMd

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Data.Settings.spacingXl

            Gauge {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "CPU"
                value: Services.SystemUsage.cpuUsage
                primary: Math.round(value * 100) + "%"
                secondary: Services.SystemUsage.cpuTemp > 0
                    ? Math.round(Services.SystemUsage.cpuTemp) + "°"
                    : "live"
                accent: Data.Settings.errorColor
            }

            Gauge {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "MEM"
                value: Services.SystemUsage.memUsage
                primary: Services.SystemUsage.memUsedGiB.toFixed(1)
                secondary: "/ " + Services.SystemUsage.memTotalGiB.toFixed(0) + " GB"
                accent: Data.Settings.accentColor
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Data.Settings.hairline
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            spacing: 0

            Metric {
                Layout.fillWidth: true
                label: "GPU"
                value: Math.round(Services.SystemUsage.gpuUsage * 100) + "%"
                accent: Data.Settings.warningColor
            }
            Divider {}
            Metric {
                Layout.fillWidth: true
                label: "DISK"
                value: Math.round(Services.SystemUsage.diskUsage * 100) + "%"
                accent: Data.Settings.accentColor
            }
            Divider {}
            Metric {
                Layout.fillWidth: true
                label: "UP"
                value: Services.SystemInfo.uptime
                accent: Data.Settings.successColor
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
            width: Math.min(parent.width, parent.height) - 4
            height: width

            onPaint: {
                const ctx = getContext("2d")
                const center = width / 2
                const radius = Math.max(8, center - 7)
                const start = Math.PI * 0.72
                const sweep = Math.PI * 1.56

                ctx.reset()
                ctx.lineWidth = 7
                ctx.lineCap = "round"
                ctx.beginPath()
                ctx.strokeStyle = Data.Settings.bgLighter
                ctx.arc(center, center, radius, start, start + sweep)
                ctx.stroke()

                ctx.beginPath()
                ctx.strokeStyle = gauge.accent
                ctx.arc(center, center, radius, start, start + sweep * Math.max(0, Math.min(1, gauge.value)))
                ctx.stroke()
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 1

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: gauge.primary
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontXl
                font.weight: Font.Bold
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: gauge.label
                color: Data.Settings.fgDim
                font.pixelSize: Data.Settings.fontXs
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 1.2
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: gauge.secondary
                color: Data.Settings.fgDim
                font.pixelSize: Data.Settings.fontXs
            }
        }
    }

    component Metric: ColumnLayout {
        required property string label
        required property string value
        required property color accent

        spacing: 2

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: label
            color: Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontXs
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.1
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: value
            color: accent
            font.pixelSize: Data.Settings.fontBase
            font.weight: Font.Bold
            elide: Text.ElideRight
        }
    }

    component Divider: Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 28
        color: Data.Settings.hairline
    }
}
