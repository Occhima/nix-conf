import QtQuick
import "root:/data" as Data

Item {
    id: root

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content
        anchors.centerIn: parent
        spacing: Data.Settings.spacingSm

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            Text {
                text: Data.Time.hours
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontBase
                font.weight: Font.Bold
            }

            Text {
                text: " : "
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontBase
                font.weight: Font.Bold

                SequentialAnimation on opacity {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 800; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
                }
            }

            Text {
                text: Data.Time.minutes
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontBase
                font.weight: Font.Bold
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Data.Time.barDate
            color: Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontSm
            font.weight: Font.Medium
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Data.Runtime.toggleCalendar()
    }
}
