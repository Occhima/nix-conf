import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/data" as Data
import "root:/services" as Services

Rectangle {
    id: root

    height: 64
    radius: 16
    color: Data.Settings.bgLight

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Data.Settings.spacingMd
        anchors.rightMargin: Data.Settings.spacingMd
        spacing: 0

        Item { Layout.fillWidth: true }

        StatItem {
            icon: "cpu-symbolic"
            label: "CPU"
            value: Services.SystemUsage.cpuUsage
            accentColor: Data.Settings.errorColor
        }

        Item { Layout.fillWidth: true }
        Rectangle { width: 1; height: 36; color: Data.Settings.borderNormal }
        Item { Layout.fillWidth: true }

        StatItem {
            icon: "memory-symbolic"
            label: "RAM"
            value: Services.SystemUsage.memUsage
            accentColor: Data.Settings.warningColor
        }

        Item { Layout.fillWidth: true }
        Rectangle { width: 1; height: 36; color: Data.Settings.borderNormal }
        Item { Layout.fillWidth: true }

        StatItem {
            icon: "drive-harddisk-symbolic"
            label: "Disk"
            value: Services.SystemUsage.diskUsage
            accentColor: Data.Settings.accentColor
        }

        Item { Layout.fillWidth: true }
    }

    component StatItem: ColumnLayout {
        property string icon
        property string label
        property real value
        property color accentColor

        spacing: Data.Settings.spacingXs

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Image {
                source: Quickshell.iconPath(icon)
                width: Data.Settings.iconSm
                height: Data.Settings.iconSm
                sourceSize: Qt.size(Data.Settings.iconSm, Data.Settings.iconSm)
            }

            Text {
                text: Math.round(value * 100) + "%"
                font.pixelSize: Data.Settings.fontLg
                font.weight: Font.Bold
                color: Data.Settings.fgColor
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 44
            Layout.preferredHeight: 3
            radius: 1.5
            color: Data.Settings.bgLighter

            Rectangle {
                width: parent.width * Math.min(value, 1)
                height: parent.height
                radius: 1.5
                color: accentColor

                Behavior on width { NumberAnimation { duration: Data.Settings.animMedium; easing.type: Easing.OutCubic } }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: label
            font.pixelSize: Data.Settings.fontXs
            font.weight: Font.Medium
            color: Data.Settings.fgDim
        }
    }
}
