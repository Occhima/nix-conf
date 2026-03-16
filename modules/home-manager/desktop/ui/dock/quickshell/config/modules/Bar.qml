import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/components/bar" as BarComponents
import "root:/data" as Data

Scope {
    Variants {
        model: Quickshell.screens

        WlrLayershell {
            id: bar

            property var modelData

            screen: modelData
            layer: WlrLayer.Top
            namespace: "quickshell-bar"
            exclusiveZone: Data.Settings.barHeight + Data.Settings.barMargin * 2

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Data.Settings.barHeight + Data.Settings.barMargin * 2
            implicitWidth: screen.width

            color: "transparent"

            Item {
                id: barContainer
                anchors.fill: parent
                anchors.topMargin: Data.Settings.barMargin
                anchors.leftMargin: Data.Settings.barSideMargin
                anchors.rightMargin: Data.Settings.barSideMargin

                // LEFT SIDE - Workspaces + Taskbar
                Row {
                    id: leftPills
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    // Workspaces Pill
                    Rectangle {
                        height: 32
                        width: workspacesContent.implicitWidth + 20
                        radius: 16
                        color: Data.Settings.bgColor
                        border.width: 1
                        border.color: Qt.rgba(255, 255, 255, 0.06)

                        Behavior on width {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
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
                                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
                                GradientStop { position: 1.0; color: "transparent" }
                            }
                        }

                        Row {
                            id: workspacesContent
                            anchors.centerIn: parent
                            spacing: 4

                            BarComponents.Workspaces {
                                anchors.verticalCenter: parent.verticalCenter
                                screen: bar.screen
                            }
                        }
                    }

                }

                // CENTER MODULE - Clock
                Rectangle {
                    id: centerModule
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    height: 32
                    width: centerRow.implicitWidth + 24
                    radius: 16
                    color: Data.Settings.bgColor
                    border.width: 1
                    border.color: Qt.rgba(255, 255, 255, 0.06)

                    // Top highlight
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 1
                        height: parent.height / 2
                        radius: parent.radius - 1
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }

                    Row {
                        id: centerRow
                        anchors.centerIn: parent
                        spacing: 6

                        BarComponents.Clock {
                            id: clockContent
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 20
                            height: 20
                            radius: 10
                            color: centerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : "transparent"

                            Behavior on color {
                                ColorAnimation { duration: 120 }
                            }

                            Image {
                                anchors.centerIn: parent
                                source: Quickshell.iconPath("view-grid-symbolic")
                                width: 14
                                height: 14
                                sourceSize: Qt.size(14, 14)
                                opacity: 0.7
                            }

                            MouseArea {
                                id: centerMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Data.Runtime.toggleDashboard()
                            }
                        }
                    }
                }

                // RIGHT SIDE - Multiple Pills
                Row {
                    id: rightPills
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    // System Tray Pill
                    Rectangle {
                        visible: sysTray.itemCount > 0
                        height: 32
                        width: sysTray.implicitWidth + 20
                        radius: 16
                        color: Data.Settings.bgColor
                        border.width: 1
                        border.color: Qt.rgba(255, 255, 255, 0.06)

                        Behavior on width {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
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
                                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
                                GradientStop { position: 1.0; color: "transparent" }
                            }
                        }

                        BarComponents.SysTray {
                            id: sysTray
                            anchors.centerIn: parent
                        }
                    }

                    // Status Icons Pill (WiFi, Bluetooth, Volume, Battery)
                    Rectangle {
                        height: 32
                        width: statusRow.implicitWidth + 20
                        radius: 16
                        color: Data.Settings.bgColor
                        border.width: 1
                        border.color: Qt.rgba(255, 255, 255, 0.06)

                        Behavior on width {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
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
                                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
                                GradientStop { position: 1.0; color: "transparent" }
                            }
                        }

                        Row {
                            id: statusRow
                            anchors.centerIn: parent
                            spacing: 6

                            BarComponents.StatusIcons {
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
