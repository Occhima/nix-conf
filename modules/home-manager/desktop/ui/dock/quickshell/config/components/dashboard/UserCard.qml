import QtQuick
import QtQuick.Layouts
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Shared.CardFrame {
    RowLayout {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingLg
        spacing: Data.Settings.spacingLg

        Rectangle {
            id: avatarWrap

            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            radius: 18
            clip: true
            color: Qt.alpha(Data.Settings.fgColor, 0.05)
            border.width: 1
            border.color: Qt.alpha(Data.Settings.fgColor, 0.06)

            Image {
                id: faceImage

                anchors.fill: parent
                source: Data.Utils.safeUrl(
                    Services.SystemInfo ? Services.SystemInfo.facePath : undefined
                )
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: false
            }

            Text {
                anchors.centerIn: parent
                visible: faceImage.status !== Image.Ready
                text: Data.Utils.safeString(
                    Services.SystemInfo ? Services.SystemInfo.user : undefined,
                    "U"
                ).charAt(0).toUpperCase()
                color: Data.Settings.fgColor
                font.pixelSize: 24
                font.weight: Font.DemiBold
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 6

            InfoRow {
                dotColor: Data.Settings.warningColor
                text: Data.Utils.safeString(
                    Services.SystemInfo ? Services.SystemInfo.osPrettyName : undefined,
                    "Linux"
                )
            }

            InfoRow {
                dotColor: Data.Settings.accentColor
                text: Data.Utils.safeString(
                    Services.SystemInfo ? Services.SystemInfo.wm : undefined,
                    "Wayland"
                )
            }

            InfoRow {
                dotColor: Data.Settings.successColor
                text: "up " + Data.Utils.safeString(
                    Services.SystemInfo ? Services.SystemInfo.uptime : undefined,
                    "..."
                )
            }
        }
    }
}
