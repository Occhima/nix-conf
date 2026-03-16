import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Io

import "root:/data" as Data
import "root:/services" as Services

Scope {
    id: btDialog

    readonly property int animShort: 150
    readonly property int animMedium: 250

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
                    topMargin: Data.Settings.barHeight + Data.Settings.barMargin * 2 + 12
                    right: parent.right
                    rightMargin: Data.Settings.barSideMargin
                }
                width: 320
                height: 430
                radius: 18
                color: Data.Settings.bgColorTranslucent
                border.width: 1
                border.color: Qt.rgba(0.7, 0.7, 1, 0.14)

                scale: Data.Runtime.bluetoothVisible ? 1.0 : 0.95
                opacity: Data.Runtime.bluetoothVisible ? 1.0 : 0.0
                transformOrigin: Item.TopRight

                Behavior on scale {
                    NumberAnimation { duration: btDialog.animMedium; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: btDialog.animShort }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

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
                                width: 18
                                height: 18
                                sourceSize: Qt.size(18, 18)
                            }
                        }

                        ColumnLayout {
                            spacing: 1
                            Text { text: "Bluetooth"; color: Data.Settings.fgColor; font.pixelSize: 18; font.weight: Font.DemiBold }
                            Text {
                                text: Services.Bluetooth.connected ? Services.Bluetooth.statusText : "No connected device"
                                color: Data.Settings.fgDim
                                font.pixelSize: 12
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Switch {
                            checked: Services.Bluetooth.powered
                            onToggled: Services.Bluetooth.toggle()
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 44
                        radius: 12
                        color: Data.Settings.bgLight

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Text { text: "⟳"; color: Data.Settings.fgColor; font.pixelSize: 16 }
                            Text { text: "Scan for devices"; color: Data.Settings.fgColor; font.pixelSize: 14; font.weight: Font.DemiBold }
                        }

                        MouseArea {
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
                        color: Qt.rgba(0.12, 0.14, 0.18, 0.7)

                        ListView {
                            id: deviceList
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 6
                            clip: true
                            model: Services.Bluetooth.devices

                            delegate: Rectangle {
                                id: deviceDelegate
                                required property BluetoothDevice modelData

                                readonly property bool isConnected: modelData && modelData.connected
                                readonly property bool isPaired: modelData && modelData.paired

                                width: ListView.view.width
                                height: modelData ? 54 : 0
                                visible: modelData !== null
                                radius: 10
                                color: Qt.rgba(0, 0, 0, 0.12)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
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
                                            text: deviceDelegate.modelData ? deviceDelegate.modelData.name || "Unknown" : "Unknown"
                                            color: Data.Settings.fgColor
                                            font.pixelSize: 14
                                            font.weight: Font.DemiBold
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            text: deviceDelegate.isConnected ? "Connected" : (deviceDelegate.isPaired ? "Paired" : "Available")
                                            color: Data.Settings.fgDim
                                            font.pixelSize: 12
                                        }
                                    }

                                    Rectangle {
                                        width: 28
                                        height: 28
                                        radius: 14
                                        color: deviceDelegate.isConnected ? Qt.rgba(0.93, 0.2, 0.25, 0.2) : Qt.rgba(1, 1, 1, 0.1)
                                        border.width: 1
                                        border.color: Qt.rgba(1, 1, 1, 0.18)

                                        Text {
                                            anchors.centerIn: parent
                                            text: deviceDelegate.isConnected ? "×" : "↔"
                                            color: Data.Settings.fgColor
                                            font.pixelSize: 16
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (deviceDelegate.modelData) {
                                                    if (deviceDelegate.isConnected) {
                                                        Services.Bluetooth.disconnectDevice(deviceDelegate.modelData)
                                                    } else {
                                                        Services.Bluetooth.connectDevice(deviceDelegate.modelData)
                                                    }
                                                }
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
                            text: "⚙ Bluetooth Settings"
                            color: Data.Settings.fgDim
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
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
