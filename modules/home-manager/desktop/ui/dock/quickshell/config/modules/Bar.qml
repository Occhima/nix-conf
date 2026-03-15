import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../components" as Components
import "../data" as Data

Scope {
    Variants {
        model: Quickshell.screens

        WlrLayershell {
            id: bar

            property var modelData

            screen: modelData
            layer: WlrLayer.Top
            namespace: "quickshell-bar"
            exclusiveZone: Data.Settings.barWidth + Data.Settings.barMargin * 2
            anchors {
                top: true
                bottom: true
                left: true
            }

            width: Data.Settings.barWidth + Data.Settings.barMargin * 2
            height: screen.height

            color: "transparent"

            Rectangle {
                anchors {
                    fill: parent
                    margins: Data.Settings.barMargin
                }
                color: Data.Settings.bgColor
                radius: Data.Settings.rounding
                border.width: 1
                border.color: Data.Settings.fgColor
                opacity: 0.9

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                    }
                    height: Math.max(24, parent.height * 0.2)
                    radius: parent.radius
                    color: Data.Settings.bgLight
                    opacity: 0.45
                }

                ColumnLayout {
                    anchors {
                        fill: parent
                        margins: 10
                    }
                    spacing: 8

                    // Top section: Workspaces
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: workspaces.implicitHeight

                        Components.Workspaces {
                            id: workspaces
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // Divider
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 20
                        height: 1
                        color: Data.Settings.fgColor
                        opacity: 0.15
                    }

                    // Spacer
                    Item { Layout.fillHeight: true }

                    // Center: Clock
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: clock.implicitHeight

                        Components.Clock {
                            id: clock
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // Spacer
                    Item { Layout.fillHeight: true }

                    // Divider
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 20
                        height: 1
                        color: Data.Settings.fgColor
                        opacity: 0.15
                    }

                    // Bottom section: System tray + status icons
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: sysTray.implicitHeight

                            Components.SysTray {
                                id: sysTray
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: noti.implicitHeight

                            Components.Noti {
                                id: noti
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: widgets.implicitHeight

                            Components.Widgets {
                                id: widgets
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: stats.implicitHeight

                            Components.SystemStats {
                                id: stats
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }



                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20

                            Components.Volume {
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: battery.visible ? 20 : 0

                            Components.Battery {
                                id: battery
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
