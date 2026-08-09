import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/components/bar" as Bar
import "root:/components/quicksettings" as QuickSettings
import "root:/components/shared" as Shared
import "root:/data" as Data
import "root:/services" as Services

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingMd

        RowLayout {
            Layout.fillWidth: true
            spacing: Data.Settings.spacingMd

            ColumnLayout {
                spacing: 1

                Text {
                    text: "Hello, " + Services.SystemInfo.user
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontLg
                    font.weight: Font.DemiBold
                }

                Text {
                    text: Services.SystemInfo.osPrettyName + " · " + Services.SystemInfo.wm
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontXs
                }
            }

            Item { Layout.fillWidth: true }

            Bar.SysTray {
                id: tray
                visible: itemCount > 0
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                Layout.preferredWidth: launchLabel.implicitWidth + Data.Settings.spacingXl
                Layout.preferredHeight: 30
                radius: 15
                color: launcherMouse.containsMouse
                    ? Qt.alpha(Data.Settings.accentColor, 0.20)
                    : Data.Settings.bgLight
                border.width: 1
                border.color: Data.Settings.borderSubtle

                Text {
                    id: launchLabel
                    anchors.centerIn: parent
                    text: "Open apps"
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontSm
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: launcherMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["anyrun"])
                }
            }
        }

        QuickSettings.SystemStats {
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Data.Settings.spacingMd

            Shared.CardFrame {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 420

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Data.Settings.spacingLg
                    spacing: Data.Settings.spacingMd

                    Text {
                        text: "Controls"
                        color: Data.Settings.fgColor
                        font.pixelSize: Data.Settings.fontBase
                        font.weight: Font.DemiBold
                    }

                    QuickSettings.ToggleGrid {
                        Layout.fillWidth: true
                    }

                    QuickSettings.VolumeSlider {
                        Layout.fillWidth: true
                    }
                }
            }

            Shared.CardFrame {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 270

                Shared.CalendarGrid {
                    anchors.fill: parent
                    anchors.margins: Data.Settings.spacingLg
                    interactive: true
                }
            }
        }
    }
}
