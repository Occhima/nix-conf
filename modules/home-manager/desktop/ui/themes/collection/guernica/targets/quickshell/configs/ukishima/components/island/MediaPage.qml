import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/components/dashboard" as Dashboard
import "root:/components/shared" as Shared
import "root:/data" as Data
import "root:/services" as Services

Item {
    RowLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingMd

        Dashboard.MediaCard {
            Layout.fillHeight: true
            Layout.preferredWidth: 330
        }

        Shared.CardFrame {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Data.Settings.spacingXl
                spacing: Data.Settings.spacingLg

                Text {
                    text: "Listening room"
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontXl
                    font.weight: Font.Bold
                }

                Text {
                    Layout.fillWidth: true
                    text: "The media surface follows any MPRIS player, while audio stays on Quickshell's PipeWire model."
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontBase
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Data.Settings.borderNormal
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Data.Settings.spacingMd

                    Image {
                        source: Quickshell.iconPath(Services.Pipewire.volumeIcon)
                        sourceSize: Qt.size(24, 24)
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        Text {
                            text: Services.Pipewire.muted ? "Audio muted" : "Output volume"
                            color: Data.Settings.fgColor
                            font.pixelSize: Data.Settings.fontBase
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: Services.Pipewire.sinkReady
                                ? Math.round(Services.Pipewire.volume * 100) + "%"
                                : "No PipeWire sink"
                            color: Data.Settings.fgDim
                            font.pixelSize: Data.Settings.fontSm
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 8
                    radius: 4
                    color: Data.Settings.bgLighter

                    Rectangle {
                        width: parent.width * Math.min(1, Services.Pipewire.volume)
                        height: parent.height
                        radius: parent.radius
                        color: Data.Settings.accentColor

                        Behavior on width {
                            NumberAnimation {
                                duration: Data.Settings.animShort
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Text {
                    Layout.fillWidth: true
                    text: Data.Time.longDate + " · " + Data.Time.time
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontSm
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
