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
                id: hours
                text: new Date().getHours().toString().padStart(2, '0')
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
                id: minutes
                text: new Date().getMinutes().toString().padStart(2, '0')
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontBase
                font.weight: Font.Bold
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                const d = new Date()
                const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                return days[d.getDay()] + " " + d.getDate()
            }
            color: Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontSm
            font.weight: Font.Medium
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            const now = new Date()
            hours.text = now.getHours().toString().padStart(2, '0')
            minutes.text = now.getMinutes().toString().padStart(2, '0')
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Data.Runtime.toggleCalendar()
    }
}
