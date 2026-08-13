import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            spacing: 8

            Text {
                text: Services.Bluetooth.adapter?.discovering ? "Scanning…" : Services.Bluetooth.statusText
                color: Services.Bluetooth.adapter?.discovering
                    ? Data.Settings.warmAccent
                    : Data.Settings.fgDim
                font.family: "monospace"
                font.pixelSize: Data.Settings.fontXs
            }

            Item { Layout.fillWidth: true }

            ActionButton {
                label: Services.Bluetooth.adapter?.discovering ? "Stop" : "Scan"
                enabled: Services.Bluetooth.powered
                accent: Data.Settings.warmAccent
                onTriggered: {
                    if (Services.Bluetooth.adapter?.discovering)
                        Services.Bluetooth.stopDiscovery()
                    else
                        Services.Bluetooth.startDiscovery()
                }
            }

            ActionButton {
                label: Services.Bluetooth.powered ? "On" : "Off"
                accent: Services.Bluetooth.powered
                    ? Data.Settings.warmAccent
                    : Data.Settings.fgDim
                onTriggered: Services.Bluetooth.toggle()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: Qt.alpha(Data.Settings.bgColor, 0.36)
            border.width: 1
            border.color: Data.Settings.borderSubtle
            clip: true

            ListView {
                id: deviceList

                anchors.fill: parent
                anchors.margins: 5
                model: Services.Bluetooth.devices
                spacing: 3
                clip: true

                delegate: Rectangle {
                    id: deviceRow

                    required property int index
                    required property BluetoothDevice modelData

                    readonly property bool connected: modelData?.connected ?? false
                    readonly property bool paired: modelData?.paired ?? false

                    width: ListView.view.width
                    height: 43
                    radius: 6
                    color: rowMouse.containsMouse ? Data.Settings.hoverBg : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 7
                        anchors.rightMargin: 5
                        spacing: 8

                        Rectangle {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            radius: 5
                            color: Data.Settings.bgLight

                            Image {
                                anchors.centerIn: parent
                                width: 14
                                height: 14
                                sourceSize: Qt.size(width, height)
                                source: Quickshell.iconPath(
                                    deviceRow.modelData.icon?.length
                                        ? deviceRow.modelData.icon
                                        : "bluetooth-symbolic"
                                )
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Text {
                                Layout.fillWidth: true
                                text: deviceRow.modelData.name || "Unknown device"
                                color: Data.Settings.fgColor
                                font.family: "monospace"
                                font.pixelSize: Data.Settings.fontSm
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                            }
                            Text {
                                Layout.fillWidth: true
                                text: deviceRow.connected
                                    ? "Connected · " + deviceRow.modelData.address
                                    : deviceRow.paired
                                        ? "Paired · " + deviceRow.modelData.address
                                        : deviceRow.modelData.address
                                color: deviceRow.connected
                                    ? Data.Settings.fgColor
                                    : Data.Settings.fgDim
                                font.family: "monospace"
                                font.pixelSize: Data.Settings.fontXs
                                elide: Text.ElideRight
                            }
                        }

                        ActionButton {
                            label: deviceRow.connected
                                ? "Drop"
                                : deviceRow.paired
                                    ? "Join"
                                    : "Pair"
                            accent: deviceRow.connected
                                ? Data.Settings.fgDim
                                : Data.Settings.warmAccent
                            onTriggered: {
                                if (deviceRow.connected)
                                    Services.Bluetooth.disconnectDevice(deviceRow.modelData)
                                else if (deviceRow.paired)
                                    Services.Bluetooth.connectDevice(deviceRow.modelData)
                                else
                                    deviceRow.modelData.pair()
                            }
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        hoverEnabled: true
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: !Services.Bluetooth.powered || deviceList.count === 0
                    text: Services.Bluetooth.powered
                        ? "No Bluetooth devices found"
                        : "Bluetooth is switched off"
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontSm
                }
            }
        }
    }

    component ActionButton: Rectangle {
        id: button

        required property string label
        property color accent: Data.Settings.warmAccent
        signal triggered()

        implicitWidth: buttonLabel.implicitWidth + 16
        implicitHeight: 23
        radius: 6
        color: buttonMouse.containsMouse
            ? Qt.alpha(accent, 0.18)
            : Qt.alpha(Data.Settings.bgLighter, 0.55)
        border.width: 1
        border.color: Qt.alpha(accent, 0.28)
        opacity: enabled ? 1 : 0.35

        Text {
            id: buttonLabel
            anchors.centerIn: parent
            text: button.label
            color: button.accent
            font.family: "monospace"
            font.pixelSize: Data.Settings.fontXs
        }

        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            enabled: button.enabled
            hoverEnabled: true
            cursorShape: button.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: button.triggered()
        }
    }
}
