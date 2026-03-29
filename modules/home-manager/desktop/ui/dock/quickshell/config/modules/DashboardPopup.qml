import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared
import "root:/components/dashboard" as Dashboard

Scope {
    id: dashboard

    property date now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            dashboard.now = new Date()
        }
    }

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-dashboard"
            visible: Data.Runtime.dashboardVisible
            exclusiveZone: 0

            anchors {
                top: true
                left: true
                right: true
            }

            implicitWidth: screen.width
            implicitHeight: panel.height + 12
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: panel

                anchors {
                    top: parent.top
                    topMargin: 6
                    horizontalCenter: parent.horizontalCenter
                }

                width: Math.min(820, screen.width - 40)
                height: content.implicitHeight + 28
                radius: Data.Settings.popupRadius
                color: Data.Settings.bgColorTranslucent
                border.width: 1
                border.color: Qt.alpha(Data.Settings.fgColor, 0.10)

                scale: Data.Runtime.dashboardVisible ? 1.0 : Data.Settings.popupScaleHidden
                opacity: Data.Runtime.dashboardVisible ? 1.0 : 0.0
                transformOrigin: Item.Top

                Behavior on scale {
                    NumberAnimation {
                        duration: Data.Settings.animMedium
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Data.Settings.animShort
                    }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 1
                    height: parent.height / 3
                    radius: parent.radius - 1
                    color: "transparent"

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: Qt.alpha("white", 0.045)
                        }
                        GradientStop {
                            position: 1.0
                            color: "transparent"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: function(mouse) {
                        mouse.accepted = true
                    }
                }

                ColumnLayout {
                    id: content

                    anchors.fill: parent
                    anchors.margins: Data.Settings.spacingLg
                    spacing: Data.Settings.spacingMd

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        spacing: Data.Settings.spacingSm

                        Text {
                            text: "Dashboard"
                            color: Data.Settings.fgColor
                            font.pixelSize: Data.Settings.fontLg
                            font.weight: Font.DemiBold
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Shared.CloseButton {
                            useIcon: false
                        }
                    }

                    RowLayout {
                        id: body

                        Layout.fillWidth: true
                        Layout.minimumHeight: 320
                        spacing: Data.Settings.spacingMd

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: Data.Settings.spacingMd

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 110
                                spacing: Data.Settings.spacingMd

                                Dashboard.WeatherCard {
                                    Layout.preferredWidth: 180
                                    Layout.fillHeight: true
                                }

                                Dashboard.UserCard {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 280
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumHeight: 200
                                spacing: Data.Settings.spacingMd

                                Dashboard.DateTimeCard {
                                    Layout.preferredWidth: 104
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 180
                                    currentTime: dashboard.now
                                }

                                Dashboard.CalendarCard {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 180
                                    currentTime: dashboard.now
                                }

                                Dashboard.ResourceBarsCard {
                                    Layout.preferredWidth: 76
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 150
                                }
                            }
                        }

                        Dashboard.MediaCard {
                            Layout.preferredWidth: 208
                            Layout.fillHeight: true
                            Layout.minimumHeight: 300
                        }
                    }
                }
            }
        }
    }
}
