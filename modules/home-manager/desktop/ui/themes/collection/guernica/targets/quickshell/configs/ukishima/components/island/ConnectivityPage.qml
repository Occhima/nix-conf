import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/components/quicksettings" as QuickSettings
import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingMd

        QuickSettings.ToggleGrid {
            Layout.fillWidth: true
        }

        QuickSettings.VolumeSlider {
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            radius: Data.Settings.rounding
            color: Data.Settings.bgLightTranslucent
            border.width: 1
            border.color: Data.Settings.borderSubtle

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Data.Settings.spacingMd
                anchors.rightMargin: Data.Settings.spacingSm
                spacing: Data.Settings.spacingSm

                Image {
                    Layout.preferredWidth: Data.Settings.iconLg
                    Layout.preferredHeight: Data.Settings.iconLg
                    sourceSize: Qt.size(width, height)
                    source: Quickshell.iconPath(Services.Networking.icon)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1

                    Text {
                        Layout.fillWidth: true
                        text: Services.Networking.statusText
                        color: Data.Settings.fgColor
                        font.pixelSize: Data.Settings.fontBase
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: Services.Networking.connected
                            ? `${Services.Networking.activeInterface || "link"}  ·  ${Services.Networking.ipv4Address || "address pending"}`
                            : Services.Bluetooth.statusText
                        color: Data.Settings.fgDim
                        font.pixelSize: Data.Settings.fontXs
                        elide: Text.ElideRight
                    }
                }

                RoundButton {
                    icon: "network-wired-symbolic"
                    onTriggered: Quickshell.execDetached(["qs-network-settings"])
                }

                RoundButton {
                    icon: "bluetooth-symbolic"
                    onTriggered: Quickshell.execDetached(["blueman-manager"])
                }
            }
        }
    }

    component RoundButton: Rectangle {
        id: button

        required property string icon
        signal triggered()

        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        radius: 16
        color: buttonMouse.containsMouse
            ? Data.Settings.hoverBg
            : Data.Settings.bgLighter

        Image {
            anchors.centerIn: parent
            width: Data.Settings.iconMd
            height: width
            sourceSize: Qt.size(width, height)
            source: Quickshell.iconPath(button.icon)
        }

        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.triggered()
        }
    }
}
