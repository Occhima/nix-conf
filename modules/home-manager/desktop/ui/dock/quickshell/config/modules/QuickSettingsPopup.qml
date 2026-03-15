import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data
import "root:/services" as Services

Scope {
    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-quicksettings"
            exclusiveZone: 0
            visible: Data.Runtime.quickSettingsVisible

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: qsContent.height + Data.Settings.barHeight + Data.Settings.barMargin * 2 + 8
            implicitWidth: screen.width

            color: "transparent"

            // Click outside to close
            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: qsContent
                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight + Data.Settings.barMargin * 2 + 8
                    right: parent.right
                    rightMargin: Data.Settings.barSideMargin
                }
                width: 300
                height: qsLayout.implicitHeight + 24
                color: Data.Settings.bgColor
                radius: Data.Settings.rounding
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.08)

                // Prevent clicks from closing
                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                ColumnLayout {
                    id: qsLayout
                    anchors {
                        fill: parent
                        margins: 12
                    }
                    spacing: 16

                    // Volume slider
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true

                            Image {
                                source: Quickshell.iconPath(Services.Pipewire.volumeIcon)
                                width: 18
                                height: 18
                                sourceSize: Qt.size(18, 18)
                            }

                            Text {
                                text: "Volume"
                                color: Data.Settings.fgColor
                                font.pixelSize: 13
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: Math.round(Services.Pipewire.volume * 100) + "%"
                                color: Data.Settings.fgDim
                                font.pixelSize: 12
                            }
                        }

                        // Volume slider track
                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: Data.Settings.bgLighter

                            Rectangle {
                                width: parent.width * Math.min(1, Services.Pipewire.volume)
                                height: parent.height
                                radius: parent.radius
                                color: Data.Settings.accentColor

                                Behavior on width {
                                    NumberAnimation { duration: 100 }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse => {
                                    const value = mouse.x / parent.width
                                    Services.Pipewire.setVolume(value)
                                }
                                onPositionChanged: mouse => {
                                    if (pressed) {
                                        const value = Math.max(0, Math.min(1, mouse.x / parent.width))
                                        Services.Pipewire.setVolume(value)
                                    }
                                }
                            }
                        }
                    }

                    // Divider
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Data.Settings.fgColor
                        opacity: 0.1
                    }

                    // Toggles row
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        // WiFi Toggle
                        Rectangle {
                            Layout.fillWidth: true
                            height: 56
                            radius: Data.Settings.rounding / 2
                            color: Services.Networking.wifiEnabled ? Data.Settings.accentColor : Data.Settings.bgLighter

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    Layout.alignment: Qt.AlignHCenter
                                    source: Quickshell.iconPath(Services.Networking.icon)
                                    width: 18
                                    height: 18
                                    sourceSize: Qt.size(18, 18)
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "WiFi"
                                    color: Services.Networking.wifiEnabled ? Data.Settings.bgColor : Data.Settings.fgColor
                                    font.pixelSize: 10
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    visible: Services.Networking.wifiConnected
                                    text: Services.Networking.wifiSsid
                                    color: Services.Networking.wifiEnabled ? Data.Settings.bgColor : Data.Settings.fgDim
                                    font.pixelSize: 8
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 60
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Services.Networking.toggleWifi()
                            }
                        }

                        // Bluetooth Toggle
                        Rectangle {
                            Layout.fillWidth: true
                            height: 56
                            radius: Data.Settings.rounding / 2
                            color: Services.Bluetooth.powered ? Data.Settings.accentColor : Data.Settings.bgLighter

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    Layout.alignment: Qt.AlignHCenter
                                    source: Quickshell.iconPath(Services.Bluetooth.icon)
                                    width: 18
                                    height: 18
                                    sourceSize: Qt.size(18, 18)
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Bluetooth"
                                    color: Services.Bluetooth.powered ? Data.Settings.bgColor : Data.Settings.fgColor
                                    font.pixelSize: 10
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    visible: Services.Bluetooth.connected
                                    text: Services.Bluetooth.connectedDevice?.name ?? ""
                                    color: Services.Bluetooth.powered ? Data.Settings.bgColor : Data.Settings.fgDim
                                    font.pixelSize: 8
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 60
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Services.Bluetooth.toggle()
                            }
                        }

                        // DND Toggle
                        Rectangle {
                            Layout.fillWidth: true
                            height: 56
                            radius: Data.Settings.rounding / 2
                            color: Services.Notifications.dnd ? Data.Settings.warningColor : Data.Settings.bgLighter

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    Layout.alignment: Qt.AlignHCenter
                                    source: Quickshell.iconPath(Services.Notifications.icon)
                                    width: 18
                                    height: 18
                                    sourceSize: Qt.size(18, 18)
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "DND"
                                    color: Services.Notifications.dnd ? Data.Settings.bgColor : Data.Settings.fgColor
                                    font.pixelSize: 10
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Services.Notifications.toggleDnd()
                            }
                        }

                        // Mute Toggle
                        Rectangle {
                            Layout.fillWidth: true
                            height: 56
                            radius: Data.Settings.rounding / 2
                            color: Services.Pipewire.muted ? Data.Settings.errorColor : Data.Settings.bgLighter

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    Layout.alignment: Qt.AlignHCenter
                                    source: Quickshell.iconPath(Services.Pipewire.muted ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic")
                                    width: 18
                                    height: 18
                                    sourceSize: Qt.size(18, 18)
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: Services.Pipewire.muted ? "Muted" : "Sound"
                                    color: Services.Pipewire.muted ? Data.Settings.bgColor : Data.Settings.fgColor
                                    font.pixelSize: 10
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Services.Pipewire.toggleMute()
                            }
                        }
                    }

                    // Divider
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Data.Settings.fgColor
                        opacity: 0.1
                    }

                    // Battery info (if present)
                    RowLayout {
                        Layout.fillWidth: true
                        visible: Services.UPower.hasBattery
                        spacing: 8

                        Image {
                            source: Quickshell.iconPath(Services.UPower.icon)
                            width: 18
                            height: 18
                            sourceSize: Qt.size(18, 18)
                        }

                        Text {
                            text: Services.UPower.tooltip
                            color: Data.Settings.fgColor
                            font.pixelSize: 12
                        }

                        Item { Layout.fillWidth: true }
                    }
                }
            }
        }
    }
}
