import QtQuick
import Quickshell
import Quickshell.Wayland

import "../services" as Services
import "../data" as Data

Scope {
    id: osd

    property bool showVolume: false

    Connections {
        target: Services.Pipewire
        function onVolumeChanged() { osd.showVolume = true; volumeTimer.restart(); }
        function onMutedChanged() { osd.showVolume = true; volumeTimer.restart(); }
    }

    Timer {
        id: volumeTimer
        interval: 1500
        onTriggered: osd.showVolume = false
    }

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-osd"
            exclusiveZone: 0
            anchors {
                bottom: true
                left: true
                right: true
            }
            visible: osd.showVolume

            height: 40

            color: "transparent"

            Rectangle {
                width: 200
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height - 8

                color: Data.Settings.bgColor


                radius: Data.Settings.rounding
                border.width: 1

                border.color: Qt.rgba(1, 1, 1, 0.08)

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Image {
                        source: Quickshell.iconPath(Services.Pipewire.volumeIcon)
                        width: 18
                        height: 18
                        sourceSize: Qt.size(18, 18)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        width: 120
                        height: 4
                        radius: 2
                        color: Data.Settings.bgLighter
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: parent.width * Math.min(1, Services.Pipewire.volume)
                            height: parent.height
                            radius: parent.radius
                            color: Data.Settings.accentColor

                            Behavior on width {
                                NumberAnimation { duration: 100 }
                            }
                        }
                    }
                }
            }
        }
    }
}
