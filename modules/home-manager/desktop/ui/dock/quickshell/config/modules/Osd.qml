import QtQuick
import Quickshell
import Quickshell.Wayland

import "root:/services" as Services
import "root:/data" as Data

Scope {
    id: root

    property bool showVolume: false

    Connections {
        target: Services.Pipewire
        function onVolumeChanged() { root.showVolume = true; timer.restart() }
        function onMutedChanged() { root.showVolume = true; timer.restart() }
    }

    Timer {
        id: timer
        interval: 1500
        onTriggered: root.showVolume = false
    }

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-osd"
            exclusiveZone: 0
            visible: root.showVolume

            anchors {
                bottom: true
                left: true
                right: true
            }

            implicitHeight: 40
            color: "transparent"

            Rectangle {
                width: 200
                height: parent.height - 8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: Data.Settings.rounding
                color: Data.Settings.bgColor
                border.width: 1
                border.color: Data.Settings.borderNormal

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

                            Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
                        }
                    }
                }
            }
        }
    }
}
