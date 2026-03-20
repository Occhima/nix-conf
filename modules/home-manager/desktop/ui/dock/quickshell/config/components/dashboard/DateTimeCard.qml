import QtQuick
import QtQuick.Layouts
import "root:/data" as Data
import "root:/components/shared" as Shared

Shared.CardFrame {
    id: root

    property date currentTime: new Date()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingMd
        spacing: Data.Settings.spacingXs

        Item { Layout.fillHeight: true }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatTime(root.currentTime, "hh\nmm")
            color: Data.Settings.fgColor
            font.pixelSize: 28
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDate(root.currentTime, "ddd, d")
            color: Data.Settings.fgDim
            font.pixelSize: 12
        }

        Item { Layout.fillHeight: true }
    }
}
