import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data
import "root:/services" as Services
import "root:/components/quicksettings" as QS

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-controlcenter"
            exclusiveZone: 0
            visible: Data.Runtime.quickSettingsVisible

            anchors {
                top: true
                right: true
            }

            implicitHeight: panelContent.height + Data.Settings.barHeight + Data.Settings.barMargin * 2 + 60
            implicitWidth: 380
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

                width: 340
                height: panelContent.implicitHeight + 40
                color: Data.Settings.bgColorTranslucent
                radius: Data.Settings.popupRadius
                border.width: 1
                border.color: Data.Settings.borderNormal
                clip: true
                transformOrigin: Item.TopRight

                scale: Data.Runtime.quickSettingsVisible ? 1.0 : Data.Settings.popupScaleHidden
                opacity: Data.Runtime.quickSettingsVisible ? 1.0 : 0.0

                Behavior on scale { NumberAnimation { duration: Data.Settings.animMedium; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: Data.Settings.animShort } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: function(mouse) { mouse.accepted = true }
                }

                ColumnLayout {
                    id: panelContent

                    anchors {
                        fill: parent
                        margins: Data.Settings.spacingXl
                    }
                    spacing: Data.Settings.spacingLg

                    QS.Header {
                        Layout.fillWidth: true
                    }

                    Divider {}

                    QS.ToggleGrid {
                        Layout.fillWidth: true
                    }

                    Divider {}

                    QS.VolumeSlider {
                        Layout.fillWidth: true
                    }

                    Divider {}

                    QS.SystemStats {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        radius: 12
                        color: Data.Settings.bgLight
                        visible: Services.UPower.hasBattery

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Data.Settings.spacingLg
                            anchors.rightMargin: Data.Settings.spacingLg
                            spacing: Data.Settings.spacingMd

                            Image {
                                source: Quickshell.iconPath(Services.UPower.icon)
                                width: 20
                                height: 20
                                sourceSize: Qt.size(20, 20)
                            }

                            Text {
                                text: Services.UPower.tooltip
                                color: Data.Settings.fgColor
                                font.pixelSize: Data.Settings.fontBase
                                font.weight: Font.Medium
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: Math.round(Services.UPower.percentage) + "%"
                                color: Data.Settings.fgDim
                                font.pixelSize: Data.Settings.fontBase
                                font.weight: Font.Bold
                            }
                        }
                    }
                }
            }
        }
    }

    component Divider: Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Data.Settings.borderNormal
    }
}
