import QtQuick
import "root:/data" as Data

Item {
    id: root

    implicitWidth: clockRow.implicitWidth
    implicitHeight: clockRow.implicitHeight

    Row {
        id: clockRow
        anchors.centerIn: parent
        spacing: 8

        // Time display with animated colon
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            // Hours
            Text {
                id: hoursText
                text: {
                    const h = new Date().getHours()
                    return h.toString().padStart(2, '0')
                }
                color: Data.Settings.fgColor
                font.pixelSize: 13
                font.weight: Font.Bold
            }

            // Animated colon separator
            Text {
                id: colonText
                text: ":"
                color: Data.Settings.accentColor
                font.pixelSize: 13
                font.weight: Font.Bold

                SequentialAnimation on opacity {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 800; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
                }
            }

            // Minutes
            Text {
                id: minutesText
                text: {
                    const m = new Date().getMinutes()
                    return m.toString().padStart(2, '0')
                }
                color: Data.Settings.fgColor
                font.pixelSize: 13
                font.weight: Font.Bold
            }
        }

        // Date (compact)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                const d = new Date()
                const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                return days[d.getDay()] + " " + d.getDate()
            }
            color: Data.Settings.fgDim
            font.pixelSize: 11
            font.weight: Font.Medium
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            const now = new Date()
            hoursText.text = now.getHours().toString().padStart(2, '0')
            minutesText.text = now.getMinutes().toString().padStart(2, '0')
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Data.Runtime.toggleCalendar()
    }
}
