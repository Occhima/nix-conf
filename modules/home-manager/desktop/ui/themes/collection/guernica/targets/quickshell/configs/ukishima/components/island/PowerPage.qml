import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/components/island" as Island
import "root:/components/shared" as Shared
import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    function run(command): void {
        Data.Runtime.closeAll()
        Quickshell.execDetached(command)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingMd

        Shared.CardFrame {
            Layout.fillWidth: true
            Layout.preferredHeight: 86

            RowLayout {
                anchors.fill: parent
                anchors.margins: Data.Settings.spacingLg
                spacing: Data.Settings.spacingLg

                Rectangle {
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    radius: 24
                    color: Qt.alpha(Data.Settings.accentColor, 0.16)

                    Text {
                        anchors.centerIn: parent
                        text: Services.SystemInfo.user.slice(0, 1).toUpperCase()
                        color: Data.Settings.fgColor
                        font.pixelSize: Data.Settings.fontXl
                        font.weight: Font.Bold
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: Services.SystemInfo.user + " on " + Services.SystemInfo.wm
                        color: Data.Settings.fgColor
                        font.pixelSize: Data.Settings.fontLg
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: Services.SystemInfo.osPrettyName + " · up " + Services.SystemInfo.uptime
                        color: Data.Settings.fgDim
                        font.pixelSize: Data.Settings.fontSm
                    }
                }

                Text {
                    visible: Services.UPower.hasBattery
                    text: Math.round(Services.UPower.percentage) + "%"
                    color: Services.UPower.charging
                        ? Data.Settings.successColor
                        : Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontLg
                    font.weight: Font.Bold
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 3
            columnSpacing: Data.Settings.spacingMd
            rowSpacing: Data.Settings.spacingMd

            Island.ActionButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "Lock"
                detail: "Secure this session"
                icon: "system-lock-screen-symbolic"
                accent: Data.Settings.blueColor
                onTriggered: root.run(["qs-lock"])
            }

            Island.ActionButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "Suspend"
                detail: "Sleep until resumed"
                icon: "weather-clear-night-symbolic"
                accent: Data.Settings.purpleColor
                onTriggered: root.run(["systemctl", "suspend"])
            }

            Island.ActionButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "Log out"
                detail: "End the current session"
                icon: "system-log-out-symbolic"
                accent: Data.Settings.warningColor
                onTriggered: root.run(["qs-logout"])
            }

            Island.ActionButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "Reboot"
                detail: "Restart the machine"
                icon: "system-reboot-symbolic"
                accent: Data.Settings.accentColor
                onTriggered: root.run(["systemctl", "reboot"])
            }

            Island.ActionButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "Power off"
                detail: "Shut the machine down"
                icon: "system-shutdown-symbolic"
                accent: Data.Settings.errorColor
                onTriggered: root.run(["systemctl", "poweroff"])
            }

            Island.ActionButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                label: "Close"
                detail: "Collapse the island"
                icon: "window-close-symbolic"
                accent: Data.Settings.fgDim
                onTriggered: Data.Runtime.closeAll()
            }
        }
    }
}
