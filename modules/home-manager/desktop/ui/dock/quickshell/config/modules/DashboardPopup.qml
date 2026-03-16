import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data
import "root:/services" as Services

Scope {
    id: dashboard

    readonly property int animShort: 160
    readonly property int animMedium: 260

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-dashboard"
            visible: Data.Runtime.dashboardVisible
            exclusiveZone: 0

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 320
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: panel
                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight + Data.Settings.barMargin * 2 + 14
                    horizontalCenter: parent.horizontalCenter
                }
                width: 680
                height: 235
                radius: 20
                color: Data.Settings.bgColorTranslucent
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.1)

                scale: Data.Runtime.dashboardVisible ? 1.0 : 0.96
                opacity: Data.Runtime.dashboardVisible ? 1.0 : 0.0
                transformOrigin: Item.Top

                Behavior on scale {
                    NumberAnimation { duration: dashboard.animMedium; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: dashboard.animShort }
                }

                // Subtle top highlight
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 1
                    height: parent.height / 3
                    radius: parent.radius - 1
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 14

                    // Centered tabs
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            DashboardTab { icon: "view-grid-symbolic"; text: "Dashboard"; active: true }
                            DashboardTab { icon: "utilities-system-monitor-symbolic"; text: "Performance"; active: true }
                            DashboardTab { icon: "user-bookmarks-symbolic"; text: "Workspaces"; active: false }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 14

                        MetricCard {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            label: "GPU temp"
                            valueText: Math.round(Services.SystemUsage.gpuTemp) + "°C"
                            usageText: Math.round(Services.SystemUsage.gpuUsage * 100) + "%"
                            subLabel: "Usage"
                            progress: Services.SystemUsage.gpuUsage
                        }

                        MetricCard {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            label: "CPU temp"
                            valueText: Math.round(Services.SystemUsage.cpuTemp) + "°C"
                            usageText: Math.round(Services.SystemUsage.cpuUsage * 100) + "%"
                            subLabel: "Usage"
                            progress: Services.SystemUsage.cpuUsage
                        }

                        MetricCard {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            label: "Memory"
                            valueText: Services.SystemUsage.memUsedGiB.toFixed(1) + "GiB"
                            usageText: Services.SystemUsage.memTotalGiB.toFixed(1) + "GiB"
                            subLabel: "Storage"
                            progress: Services.SystemUsage.memUsage
                        }
                    }
                }
            }
        }
    }

    component DashboardTab: Rectangle {
        id: tab
        property string icon: ""
        property string text: ""
        property bool active: false

        implicitHeight: 30
        implicitWidth: tabContent.implicitWidth + 20
        radius: 15
        color: active ? Qt.rgba(255, 255, 255, 0.08) : (tabMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent")

        Behavior on color {
            ColorAnimation { duration: dashboard.animShort }
        }

        Row {
            id: tabContent
            anchors.centerIn: parent
            spacing: 6

            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: Quickshell.iconPath(tab.icon)
                width: 14
                height: 14
                sourceSize: Qt.size(14, 14)
                opacity: tab.active ? 1.0 : 0.6
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: tab.text
                color: tab.active ? Data.Settings.fgColor : Data.Settings.fgDim
                font.pixelSize: 12
                font.weight: tab.active ? Font.DemiBold : Font.Medium
            }
        }

        MouseArea {
            id: tabMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    component MetricCard: Rectangle {
        id: metricCard
        property string label: ""
        property string valueText: ""
        property string usageText: ""
        property string subLabel: ""
        property real progress: 0.0

        radius: 14
        color: Data.Settings.bgLight
        border.width: 1
        border.color: metricMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.06)

        Behavior on border.color {
            ColorAnimation { duration: dashboard.animShort }
        }

        // Top highlight
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 1
            height: parent.height / 2
            radius: parent.radius - 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.03) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 12

            CircularGauge {
                anchors.centerIn: parent
                size: Math.min(parent.width, parent.height) - 4
                progress: metricCard.progress
            }

            Column {
                anchors.centerIn: parent
                spacing: 2

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: metricCard.valueText
                    color: Data.Settings.fgColor
                    font.pixelSize: 32
                    font.weight: Font.Normal
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6

                    Text {
                        text: metricCard.label
                        color: Data.Settings.fgDim
                        font.pixelSize: 11
                    }

                    Text {
                        text: metricCard.usageText
                        color: Data.Settings.accentColor
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: metricCard.subLabel
                        color: Data.Settings.fgDim
                        font.pixelSize: 11
                    }
                }
            }
        }

        MouseArea {
            id: metricMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    component CircularGauge: Item {
        property real progress: 0
        property int size: 120

        width: size
        height: size

        property real animatedProgress: 0
        onProgressChanged: animatedProgress = Math.max(0, Math.min(1, progress))
        Component.onCompleted: animatedProgress = Math.max(0, Math.min(1, progress))

        Behavior on animatedProgress {
            NumberAnimation { duration: dashboard.animMedium; easing.type: Easing.OutCubic }
        }

        Canvas {
            id: gaugeCanvas
            anchors.fill: parent

            property real displayProgress: parent.animatedProgress

            onDisplayProgressChanged: requestPaint()

            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();

                const cx = width / 2;
                const cy = height / 2;
                const radius = Math.min(width, height) / 2 - 6;

                ctx.lineWidth = 6;
                ctx.lineCap = "round";

                // Background track
                ctx.beginPath();
                ctx.strokeStyle = Qt.rgba(255, 255, 255, 0.08);
                ctx.arc(cx, cy, radius, 0, Math.PI * 2, false);
                ctx.stroke();

                // Progress arc
                const start = -Math.PI / 2;
                const span = Math.PI * 2;

                ctx.beginPath();
                ctx.strokeStyle = Data.Settings.accentColor;
                ctx.arc(cx, cy, radius, start, start + (span * displayProgress), false);
                ctx.stroke();
            }
        }
    }
}
