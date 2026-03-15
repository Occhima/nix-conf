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

            RowLayout {
                anchors {
                    fill: parent
                    topMargin: Data.Settings.barMargin
                    leftMargin: Data.Settings.barSideMargin
                    rightMargin: Data.Settings.barSideMargin
                }
                spacing: 8

                // Left section: Workspaces pill
                Rectangle {
                    Layout.preferredHeight: Data.Settings.barHeight
                    Layout.preferredWidth: workspacesRow.implicitWidth + 20
                    Layout.alignment: Qt.AlignVCenter
                    color: Data.Settings.bgColor
                    radius: Data.Settings.rounding
                    opacity: 0.95

                    Row {
                        id: workspacesRow
                        anchors.centerIn: parent
                        spacing: 4

                        BarComponents.Workspaces {
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                // Spacer
                Item { Layout.fillWidth: true }

                // Center section: Clock pill
                Rectangle {
                    Layout.preferredHeight: Data.Settings.barHeight
                    Layout.preferredWidth: clock.implicitWidth + 32
                    Layout.alignment: Qt.AlignVCenter
                    color: Data.Settings.bgColor
                    radius: Data.Settings.rounding
                    opacity: 0.95

                    BarComponents.Clock {
                        id: clock
                        anchors.centerIn: parent
                    }
                }

                // Spacer
                Item { Layout.fillWidth: true }

                // Right section: Multiple pills
                Row {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 8

                    // System tray pill
                    Rectangle {
                        visible: sysTray.itemCount > 0
                        height: Data.Settings.barHeight
                        width: sysTray.implicitWidth + 20
                        color: Data.Settings.bgColor
                        radius: Data.Settings.rounding
                        opacity: 0.95

                        BarComponents.SysTray {
                            id: sysTray
                            anchors.centerIn: parent
                        }
                    }

                    // Status icons pill
                    Rectangle {
                        height: Data.Settings.barHeight
                        width: statusIcons.implicitWidth + 20
                        color: Data.Settings.bgColor
                        radius: Data.Settings.rounding
                        opacity: 0.95

                        BarComponents.StatusIcons {
                            id: statusIcons
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }
}
