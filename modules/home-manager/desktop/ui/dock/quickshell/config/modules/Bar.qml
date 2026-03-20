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
                id: container

                anchors.fill: parent
                anchors.topMargin: Data.Settings.barMargin
                anchors.leftMargin: Data.Settings.barSideMargin
                anchors.rightMargin: Data.Settings.barSideMargin

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Data.Settings.spacingSm

                    BarPill {
                        Row {
                            id: workspacesRow
                            anchors.centerIn: parent
                            spacing: Data.Settings.spacingXs

                            BarComponents.Workspaces {
                                anchors.verticalCenter: parent.verticalCenter
                                screen: bar.screen
                            }
                        }

                        implicitWidth: workspacesRow.implicitWidth + Data.Settings.spacingXl
                    }
                }

                BarPill {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: centerRow.implicitWidth + Data.Settings.spacingXxl

                    Row {
                        id: centerRow
                        anchors.centerIn: parent
                        spacing: 6

                        BarComponents.Clock {
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 20
                            height: 20
                            radius: 10
                            color: dashMouse.containsMouse ? Data.Settings.borderHover : "transparent"

                            Behavior on color { ColorAnimation { duration: Data.Settings.animFast } }

                            Image {
                                anchors.centerIn: parent
                                source: Quickshell.iconPath("view-grid-symbolic")
                                width: Data.Settings.iconSm
                                height: Data.Settings.iconSm
                                sourceSize: Qt.size(Data.Settings.iconSm, Data.Settings.iconSm)
                                opacity: 0.7
                            }

                            MouseArea {
                                id: dashMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Data.Runtime.toggleDashboard()
                            }
                        }
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Data.Settings.spacingSm

                    BarPill {
                        visible: sysTray.itemCount > 0
                        implicitWidth: sysTray.implicitWidth + Data.Settings.spacingXl

                        BarComponents.SysTray {
                            id: sysTray
                            anchors.centerIn: parent
                        }
                    }

                    BarPill {
                        implicitWidth: statusRow.implicitWidth + Data.Settings.spacingXl

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

    component BarPill: Rectangle {
        default property alias content: contentItem.data

        height: 32
        radius: 16
        color: Data.Settings.bgColor
        border.width: 1
        border.color: Data.Settings.borderSubtle

        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 1
            height: parent.height / 2
            radius: parent.radius - 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: Data.Settings.borderSubtle }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Item {
            id: contentItem
            anchors.fill: parent
        }
    }
}
