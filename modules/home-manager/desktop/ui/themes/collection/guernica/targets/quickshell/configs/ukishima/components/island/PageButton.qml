import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data

Rectangle {
    id: root

    required property string page
    required property string label
    required property string icon
    property bool active: Data.Runtime.activePage === page

    signal triggered()

    implicitHeight: 34
    radius: height / 2
    color: active
        ? Qt.alpha(Data.Settings.accentColor, 0.20)
        : buttonMouse.containsMouse
            ? Data.Settings.hoverBg
            : "transparent"
    border.width: 1
    border.color: active
        ? Qt.alpha(Data.Settings.accentColor, 0.48)
        : "transparent"

    Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
    Behavior on border.color { ColorAnimation { duration: Data.Settings.animShort } }

    RowLayout {
        anchors.centerIn: parent
        spacing: Data.Settings.spacingSm

        Image {
            source: Quickshell.iconPath(root.icon)
            sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
            Layout.preferredWidth: Data.Settings.iconMd
            Layout.preferredHeight: Data.Settings.iconMd
            opacity: root.active ? 1.0 : 0.72
        }

        Text {
            text: root.label
            color: root.active ? Data.Settings.fgColor : Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontSm
            font.weight: root.active ? Font.DemiBold : Font.Medium
        }
    }

    MouseArea {
        id: buttonMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
