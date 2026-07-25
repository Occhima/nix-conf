import QtQuick
import QtQuick.Layouts
import "root:/data" as Data
import "root:/components/shared" as Shared

Shared.CardFrame {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingMd
        spacing: Data.Settings.spacingXs

        Item { Layout.fillHeight: true }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Data.Time.stackedTime
            color: Data.Settings.fgColor
            font.pixelSize: 28
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Data.Time.shortDate
            color: Data.Settings.fgDim
            font.pixelSize: 12
        }

        Item { Layout.fillHeight: true }
    }
}
