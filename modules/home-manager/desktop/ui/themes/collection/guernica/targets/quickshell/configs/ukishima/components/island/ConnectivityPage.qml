import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/components/quicksettings" as QuickSettings
import "root:/components/shared" as Shared
import "root:/data" as Data
import "root:/services" as Services

Item {
    RowLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingMd

        Shared.CardFrame {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 430

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Data.Settings.spacingLg
                spacing: Data.Settings.spacingLg

                Text {
                    text: "Connectivity"
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontLg
                    font.weight: Font.DemiBold
                }

                QuickSettings.ToggleGrid {
                    Layout.fillWidth: true
                }

                QuickSettings.VolumeSlider {
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }
            }
        }

        Shared.CardFrame {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 280

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Data.Settings.spacingLg
                spacing: Data.Settings.spacingMd

                Text {
                    text: "Current links"
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontLg
                    font.weight: Font.DemiBold
                }

                LinkRow {
                    icon: Services.Networking.icon
                    label: "Network"
                    detail: Services.Networking.statusText
                    accent: Services.Networking.connected
                        ? Data.Settings.successColor
                        : Data.Settings.warningColor
                }

                LinkRow {
                    icon: Services.Bluetooth.icon
                    label: "Bluetooth"
                    detail: Services.Bluetooth.statusText
                    accent: Services.Bluetooth.connected
                        ? Data.Settings.blueColor
                        : Data.Settings.fgDim
                }

                LinkRow {
                    visible: Services.UPower.hasBattery
                    icon: Services.UPower.icon
                    label: "Battery"
                    detail: Services.UPower.tooltip
                    accent: Services.UPower.charging
                        ? Data.Settings.successColor
                        : Data.Settings.accentColor
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Data.Settings.spacingSm

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        radius: 17
                        color: networkSettingsMouse.containsMouse
                            ? Data.Settings.hoverBg
                            : Data.Settings.bgLight
                        border.width: 1
                        border.color: Data.Settings.borderNormal

                        Text {
                            anchors.centerIn: parent
                            text: "Network settings"
                            color: Data.Settings.fgColor
                            font.pixelSize: Data.Settings.fontSm
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: networkSettingsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["qs-network-settings"])
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 42
                        Layout.preferredHeight: 34
                        radius: 17
                        color: bluetoothSettingsMouse.containsMouse
                            ? Data.Settings.hoverBg
                            : Data.Settings.bgLight
                        border.width: 1
                        border.color: Data.Settings.borderNormal

                        Image {
                            anchors.centerIn: parent
                            source: Quickshell.iconPath("bluetooth-symbolic")
                            sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
                            width: Data.Settings.iconMd
                            height: Data.Settings.iconMd
                        }

                        MouseArea {
                            id: bluetoothSettingsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["blueman-manager"])
                        }
                    }
                }
            }
        }
    }

    component LinkRow: Rectangle {
        id: linkRow

        required property string icon
        required property string label
        required property string detail
        property color accent: Data.Settings.accentColor

        Layout.fillWidth: true
        Layout.preferredHeight: 62
        radius: Data.Settings.rounding
        color: Data.Settings.bgLight
        border.width: 1
        border.color: Data.Settings.borderSubtle

        RowLayout {
            anchors.fill: parent
            anchors.margins: Data.Settings.spacingMd
            spacing: Data.Settings.spacingMd

            Rectangle {
                Layout.preferredWidth: 34
                Layout.preferredHeight: 34
                radius: 17
                color: Qt.alpha(linkRow.accent, 0.16)

                Image {
                    anchors.centerIn: parent
                    source: Quickshell.iconPath(linkRow.icon)
                    sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
                    width: Data.Settings.iconMd
                    height: Data.Settings.iconMd
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    Layout.fillWidth: true
                    text: linkRow.label
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontBase
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: linkRow.detail
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontXs
                    elide: Text.ElideRight
                }
            }
        }
    }
}
