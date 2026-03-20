import QtQuick
import QtQuick.Layouts
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Shared.CardFrame {
    Row {
        anchors.centerIn: parent
        spacing: 10

        ResourceBar {
            value: Services.SystemUsage ? Services.SystemUsage.cpuUsage : 0
            fillColor: Data.Settings.warningColor
            label: "C"
        }

        ResourceBar {
            value: Services.SystemUsage ? Services.SystemUsage.memUsage : 0
            fillColor: Data.Settings.accentColor
            label: "M"
        }

        ResourceBar {
            value: Services.SystemUsage ? Services.SystemUsage.diskUsage : 0
            fillColor: Data.Settings.purpleColor
            label: "D"
        }
    }

    component ResourceBar: Item {
        property real value: 0
        property color fillColor: "white"
        property string label: ""

        width: 12
        height: 132

        Rectangle {
            id: track

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: 8
            height: parent.height - 18
            radius: 4
            color: Qt.alpha(Data.Settings.fgColor, 0.08)

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: Math.max(4, track.height * Data.Utils.clamp01(parent.parent.value))
                radius: 4
                color: parent.parent.fillColor

                Behavior on height {
                    NumberAnimation {
                        duration: Data.Settings.animMedium
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.label
            color: Data.Settings.fgDim
            font.pixelSize: 9
            font.weight: Font.DemiBold
        }
    }
}
