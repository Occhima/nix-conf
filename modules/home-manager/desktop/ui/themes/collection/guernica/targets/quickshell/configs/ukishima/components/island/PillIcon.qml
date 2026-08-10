import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data

Rectangle {
    id: root

    property string icon: ""
    property string text: ""
    property color accent: Data.Settings.accentColor
    property bool selected: false
    property bool unread: false

    signal triggered()

    implicitWidth: iconRow.implicitWidth
    implicitHeight: 24
    radius: height / 2
    color: iconMouse.containsMouse ? Data.Settings.hoverBg : "transparent"

    Behavior on color { ColorAnimation { duration: Data.Settings.animFast } }

    RowLayout {
        id: iconRow
        anchors.centerIn: parent
        spacing: 5

        Item {
            visible: root.icon.length > 0
            Layout.preferredWidth: Data.Settings.iconMd
            Layout.preferredHeight: Data.Settings.iconMd

            Image {
                anchors.fill: parent
                // A text-only status (the battery percentage) intentionally
                // has no icon. Do not ask the icon provider to resolve "".
                source: root.icon.length > 0
                    ? Quickshell.iconPath(root.icon)
                    : ""
                sourceSize: Qt.size(Data.Settings.iconMd, Data.Settings.iconMd)
                opacity: root.enabled ? (root.selected ? 1 : 0.72) : 0.28
            }

            Rectangle {
                visible: root.unread
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: -3
                anchors.rightMargin: -3
                width: 5
                height: 5
                radius: 3
                color: root.accent
            }
        }

        Text {
            visible: root.text.length > 0
            text: root.text
            color: root.selected ? root.accent : Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontSm
            font.weight: Font.DemiBold
        }
    }

    MouseArea {
        id: iconMouse
        anchors.fill: parent
        anchors.margins: -5
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.triggered()
    }
}
