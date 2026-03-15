import QtQuick
import "root:/data" as Data

Rectangle {
    id: root

    property bool hovered: mouseArea.containsMouse

    implicitWidth: timeText.implicitWidth + 16
    implicitHeight: parent.height

    color: hovered ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
    radius: Data.Settings.rounding / 2

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: {
            const now = new Date()
            const hours = String(now.getHours()).padStart(2, '0')
            const minutes = String(now.getMinutes()).padStart(2, '0')
            return hours + ":" + minutes
        }
        color: Data.Settings.fgColor
        font.pixelSize: 14
        font.weight: Font.Medium
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeText.text = Qt.binding(function() {
            const now = new Date()
            const hours = String(now.getHours()).padStart(2, '0')
            const minutes = String(now.getMinutes()).padStart(2, '0')
            return hours + ":" + minutes
        })
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Data.Runtime.toggleCalendar()
    }
}
