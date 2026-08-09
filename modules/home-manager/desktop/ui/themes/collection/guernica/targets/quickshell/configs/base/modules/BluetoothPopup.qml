import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Io

import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-bluetooth"
            visible: Data.Runtime.bluetoothVisible
            exclusiveZone: 0

            anchors {
                top: true
                right: true
            }

            implicitWidth: 420
            implicitHeight: 560
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: panel

                anchors {
                    top: parent.top
                    topMargin: 4
                    right: parent.right
                    rightMargin: Data.Settings.barSideMargin
                }

                width: 320
                height: 430
                radius: 18
                color: Data.Settings.bgColorTranslucent
                border.width: 1
                border.color: Data.Settings.borderNormal
                clip: true
                transformOrigin: Item.TopRight

                scale: Data.Runtime.bluetoothVisible ? 1.0 : Data.Settings.popupScaleHidden
                opacity: Data.Runtime.bluetoothVisible ? 1.0 : 0.0

                Behavior on scale { NumberAnimation { duration: Data.Settings.animMedium; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: Data.Settings.animShort } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Data.Settings.spacingLg
                    spacing: Data.Settings.spacingMd

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            radius: 10
                            color: Data.Settings.bgLight

                            Image {
                                anchors.centerIn: parent
                                source: Quickshell.iconPath("bluetooth-symbolic")
                                width: Data.Settings.iconLg
                                height: Data.Settings.iconLg
                                sourceSize: Qt.size(Data.Settings.iconLg, Data.Settings.iconLg)
                            }
                        }

                        ColumnLayout {
                            spacing: 1

                            Text {
                                text: "Bluetooth"
                                color: Data.Settings.fgColor
                                font.pixelSize: Data.Settings.fontXl
                                font.weight: Font.DemiBold
                            }

                            Text {
                                text: Services.Bluetooth.connected ? Services.Bluetooth.statusText : "No connected device"
                                color: Data.Settings.fgDim
                                font.pixelSize: 12
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Shared.CloseButton {
                            useIcon: false
                        }

                        Switch {
                            checked: Services.Bluetooth.powered
                            onToggled: Services.Bluetooth.toggle()
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 44
                        radius: 12
                        color: scanMouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight

                        Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }

                        Row {
                            anchors.centerIn: parent
                            spacing: Data.Settings.spacingSm

                            Text {
                                text: "\u27f3"
                                color: Data.Settings.fgColor
                                font.pixelSize: 16
                            }

                            Text {
                                text: "Scan for devices"
                                color: Data.Settings.fgColor
                                font.pixelSize: Data.Settings.fontLg
                                font.weight: Font.DemiBold
                            }
                        }

                        MouseArea {
                            id: scanMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Services.Bluetooth.startDiscovery()
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 14
                        color: Data.Settings.bgLight

                        ListView {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 6
                            clip: true
                            model: Services.Bluetooth.devices

                            delegate: Rectangle {
                                id: deviceItem

                                required property BluetoothDevice modelData

                                readonly property bool isConnected: modelData?.connected ?? false
                                readonly property bool isPaired: modelData?.paired ?? false

                                width: ListView.view.width
                                height: modelData ? 54 : 0
                                visible: modelData !== null
                                radius: 10
                                color: deviceMouse.containsMouse ? Data.Settings.borderSubtle : Qt.rgba(0, 0, 0, 0.12)

                                Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }

                                MouseArea {
                                    id: deviceMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: Data.Settings.spacingMd
                                    anchors.rightMargin: 10
                                    spacing: 10

                                    Text {
                                        text: "󰋋"
                                        color: Data.Settings.fgColor
                                        font.pixelSize: 16
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        Text {
                                            text: deviceItem.modelData?.name ?? "Unknown"
                                            color: Data.Settings.fgColor
                                            font.pixelSize: Data.Settings.fontLg
                                            font.weight: Font.DemiBold
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            text: deviceItem.isConnected ? "Connected" : (deviceItem.isPaired ? "Paired" : "Available")
                                            color: Data.Settings.fgDim
                                            font.pixelSize: 12
                                        }
                                    }

                                    Rectangle {
                                        width: 28
                                        height: 28
                                        radius: 14
                                        color: deviceItem.isConnected ? Qt.rgba(0.93, 0.2, 0.25, 0.2) : Data.Settings.hoverBg
                                        border.width: 1
                                        border.color: Data.Settings.borderHover

                                        Text {
                                            anchors.centerIn: parent
                                            text: deviceItem.isConnected ? "\u00d7" : "\u2194"
                                            color: Data.Settings.fgColor
                                            font.pixelSize: 16
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (!deviceItem.modelData) return
                                                if (deviceItem.isConnected)
                                                    Services.Bluetooth.disconnectDevice(deviceItem.modelData)
                                                else
                                                    Services.Bluetooth.connectDevice(deviceItem.modelData)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 34
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "\u2699 Bluetooth Settings"
                            color: settingsMouse.containsMouse ? Data.Settings.fgColor : Data.Settings.fgDim

                            Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
                        }

                        MouseArea {
                            id: settingsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: btSettings.running = true
                        }
                    }
                }
            }
        }
    }

    Process {
        id: btSettings
        command: ["blueman-manager"]
        onStarted: Data.Runtime.closeAll()
    }
}
