import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/data" as Data

RowLayout {
    id: root

    spacing: Data.Settings.spacingSm

    function run(command: string): void {
        Data.Runtime.closeAll()
        Quickshell.execDetached([command])
    }

    ColumnLayout {
        spacing: 2

        Text {
            text: Data.Time.time
            font.pixelSize: Data.Settings.fontXxl
            font.weight: Font.Bold
            color: Data.Settings.fgColor
        }

        Text {
            text: Data.Time.longDate
            font.pixelSize: Data.Settings.fontBase
            font.weight: Font.Medium
            color: Data.Settings.fgDim
        }

    }

    Item { Layout.fillWidth: true }

    RowLayout {
        spacing: 6

        HeaderButton {
            icon: "preferences-system-symbolic"
            onClicked: root.run("qs-network-settings")
        }
        HeaderButton {
            icon: "system-lock-screen-symbolic"
            onClicked: root.run("qs-lock")
        }
        HeaderButton {
            icon: "system-shutdown-symbolic"
            onClicked: root.run("qs-logout")
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
