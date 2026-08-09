import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Shared.CardFrame {
    id: root

    implicitHeight: 178

    function percentText(value) {
        return `${Math.round(Data.Utils.clamp01(value) * 100)}%`
    }

    function tempText(value) {
        return value > 0 ? `${Math.round(value)}°C` : "--"
    }

    function gibText(value) {
        return `${Math.max(0, value).toFixed(1)} GiB`
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingLg
        spacing: Data.Settings.spacingMd

        MetricTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "GPU"
            icon: "video-display-symbolic"
            value: Services.SystemUsage.gpuUsage
            accentColor: Data.Settings.purpleColor
            centerText: root.tempText(Services.SystemUsage.gpuTemp)
            centerCaption: "Temp"
            footerLeft: "Usage"
            footerRight: root.percentText(Services.SystemUsage.gpuUsage)
        }

        MetricTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "CPU"
            icon: "cpu-symbolic"
            value: Services.SystemUsage.cpuUsage
            accentColor: Data.Settings.accentColor
            centerText: root.tempText(Services.SystemUsage.cpuTemp)
            centerCaption: "Temp"
            footerLeft: "Usage"
            footerRight: root.percentText(Services.SystemUsage.cpuUsage)
        }

        MetricTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Memory"
            icon: "memory-symbolic"
            value: Services.SystemUsage.memUsage
            accentColor: Data.Settings.warningColor
            centerText: root.gibText(Services.SystemUsage.memUsedGiB)
            centerCaption: "Used"
            footerLeft: "Total"
            footerRight: root.gibText(Services.SystemUsage.memTotalGiB)
        }

        MetricTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Storage"
            icon: "drive-harddisk-symbolic"
            value: Services.SystemUsage.diskUsage
            accentColor: Data.Settings.successColor
            centerText: root.gibText(Services.SystemUsage.diskUsedGiB)
            centerCaption: "Used"
            footerLeft: "Total"
            footerRight: root.gibText(Services.SystemUsage.diskTotalGiB)
            centerFontSize: Data.Settings.fontLg
        }
    }

    component MetricTile: Item {
        id: tile

        property string title: ""
        property string icon: ""
        property real value: 0
        property color accentColor: Data.Settings.accentColor
        property string centerText: "--"
        property string centerCaption: ""
        property int centerFontSize: Data.Settings.fontXl
        property string footerLeft: ""
        property string footerRight: ""

        readonly property real normalizedValue: Data.Utils.clamp01(value)
        property real animatedValue: normalizedValue

        onNormalizedValueChanged: animatedValue = normalizedValue

        Behavior on animatedValue {
            NumberAnimation {
                duration: Data.Settings.animMedium
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: Data.Settings.spacingSm

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Image {
                    source: Quickshell.iconPath(tile.icon)
                    width: Data.Settings.iconSm
                    height: Data.Settings.iconSm
                    sourceSize: Qt.size(width, height)
                    smooth: true
                }

                Text {
                    Layout.fillWidth: true
                    text: tile.title
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontSm
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 104

                Canvas {
                    id: ring

                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height)
                    height: width
                    antialiasing: true

                    Connections {
                        target: tile

                        function onAnimatedValueChanged() {
                            ring.requestPaint()
                        }
                    }

                    onPaint: {
                        const ctx = getContext("2d")
                        const lineWidth = 8
                        const start = Math.PI * 0.75
                        const sweep = Math.PI * 1.5
                        const radius = (Math.min(width, height) / 2) - lineWidth
                        const cx = width / 2
                        const cy = height / 2

                        ctx.reset()
                        ctx.lineWidth = lineWidth
                        ctx.lineCap = "round"

                        ctx.beginPath()
                        ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.10)
                        ctx.arc(cx, cy, radius, start, start + sweep, false)
                        ctx.stroke()

                        ctx.beginPath()
                        ctx.strokeStyle = tile.accentColor
                        ctx.arc(
                            cx,
                            cy,
                            radius,
                            start,
                            start + sweep * tile.animatedValue,
                            false
                        )
                        ctx.stroke()
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: tile.centerText
                        color: Data.Settings.fgColor
                        font.pixelSize: tile.centerFontSize
                        font.weight: Font.DemiBold
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: tile.centerCaption
                        color: Data.Settings.fgDim
                        font.pixelSize: Data.Settings.fontXs
                        font.weight: Font.Medium
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: tile.footerLeft
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontXs
                    font.weight: Font.Medium
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: tile.footerRight
                    color: tile.accentColor
                    font.pixelSize: Data.Settings.fontXs
                    font.weight: Font.DemiBold
                }
            }
        }
    }
}
