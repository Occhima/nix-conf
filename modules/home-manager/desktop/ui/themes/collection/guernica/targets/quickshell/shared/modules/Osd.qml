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
                height: parent.height - Data.Settings.spacingSm
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
                        width: Data.Settings.iconLg
                        height: Data.Settings.iconLg
                        sourceSize: Qt.size(Data.Settings.iconLg, Data.Settings.iconLg)
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

                            Behavior on width { NumberAnimation { duration: Data.Settings.animFast; easing.type: Easing.OutCubic } }
                        }
                    }
                }
            }
        }
    }
}
