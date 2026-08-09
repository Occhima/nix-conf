import QtQuick
import QtQuick.Layouts
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Shared.CardFrame {
    RowLayout {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingLg
        spacing: Data.Settings.spacingMd

        Text {
            text: Data.Utils.weatherIcon(Services.Weather ? Services.Weather.description : "")
            color: Data.Settings.warningColor
            font.pixelSize: 34
            font.weight: Font.Light
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: Data.Utils.safeString(
                    Services.Weather ? Services.Weather.temperature : undefined,
                    "--\u00b0"
                )
                color: Data.Settings.fgColor
                font.pixelSize: 30
                font.weight: Font.Medium
            }

            Text {
                text: Data.Utils.safeString(
                    Services.Weather ? Services.Weather.description : undefined,
                    "Weather"
                )
                color: Data.Settings.fgDim
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }
    }
}
