import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "root:/data" as Data

RowLayout {
    id: root

    spacing: Data.Settings.spacingSm

    Process {
        id: settingsProcess
        command: ["qs-network-settings"]
        onStarted: Data.Runtime.closeAll()
    }

    Process {
        id: lockProcess
        command: ["qs-lock"]
        onStarted: Data.Runtime.closeAll()
    }

    Process {
        id: powerProcess
        command: ["qs-logout"]
        onStarted: Data.Runtime.closeAll()
    }

    ColumnLayout {
        spacing: 2

        Text {
            id: timeText
            text: Qt.formatTime(new Date(), "hh:mm")
            font.pixelSize: Data.Settings.fontXxl
            font.weight: Font.Bold
            color: Data.Settings.fgColor
        }

        Text {
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font.pixelSize: Data.Settings.fontBase
            font.weight: Font.Medium
            color: Data.Settings.fgDim
        }

        Timer {
            interval: 1000
            running: Data.Runtime.quickSettingsVisible
            repeat: true
            onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    Item { Layout.fillWidth: true }

    RowLayout {
        spacing: 6

        HeaderButton {
            icon: "preferences-system-symbolic"
            onClicked: settingsProcess.running = true
        }
        HeaderButton {
            icon: "system-lock-screen-symbolic"
            onClicked: lockProcess.running = true
        }
        HeaderButton {
            icon: "system-shutdown-symbolic"
            onClicked: powerProcess.running = true
        }
    }

    Rectangle {
        width: 1
        height: 24
        color: Data.Settings.borderNormal
    }

    Rectangle {
        id: closeBtn

        width: 36
        height: 36
        radius: 18
        color: closeMouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight
        scale: closeMouse.pressed ? 0.92 : 1.0

        Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
        Behavior on scale { NumberAnimation { duration: Data.Settings.animFast; easing.type: Easing.OutCubic } }

        Image {
            anchors.centerIn: parent
            source: Quickshell.iconPath("window-close-symbolic")
            width: Data.Settings.iconMd
            height: Data.Settings.iconMd
            sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
        }

        MouseArea {
            id: closeMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Data.Runtime.closeAll()
        }
    }

    component HeaderButton: Rectangle {
        id: btn

        property string icon
        signal clicked()

        width: 36
        height: 36
        radius: 18
        color: btnMouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight
        scale: btnMouse.pressed ? 0.92 : 1.0

        Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
        Behavior on scale { NumberAnimation { duration: Data.Settings.animFast; easing.type: Easing.OutCubic } }

        Image {
            anchors.centerIn: parent
            source: Quickshell.iconPath(btn.icon)
            width: Data.Settings.iconMd
            height: Data.Settings.iconMd
            sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
        }

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: btn.clicked()
        }
    }
}
