import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data

Rectangle {
    id: root

    required property string icon
    property string text: ""
    property color accent: Data.Settings.fgColor

    implicitWidth: chipRow.implicitWidth + Data.Settings.spacingMd
    implicitHeight: 26
    radius: height / 2
    color: Qt.alpha(accent, chipMouse.containsMouse ? 0.18 : 0.10)
    border.width: 1
    border.color: Qt.alpha(accent, 0.20)

    signal triggered()

    RowLayout {
        id: chipRow
        anchors.centerIn: parent
        spacing: Data.Settings.spacingXs

        Image {
            source: Quickshell.iconPath(root.icon)
            sourceSize: Qt.size(Data.Settings.iconSm, Data.Settings.iconSm)
            Layout.preferredWidth: Data.Settings.iconSm
            Layout.preferredHeight: Data.Settings.iconSm
        }

        Text {
            visible: text !== ""
            text: root.text
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontXs
            font.weight: Font.DemiBold
        }
    }

    MouseArea {
        id: chipMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
