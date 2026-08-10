import QtQuick
import QtQuick.Layouts

import "root:/data" as Data

Rectangle {
    id: root

    property string glyph: ""
    property string text: ""
    property color accent: Data.Settings.accentColor
    property bool selected: false
    property bool unread: false

    signal triggered()

    implicitWidth: iconRow.implicitWidth + 10
    implicitHeight: 30
    radius: 6
    color: iconMouse.containsMouse ? Data.Settings.hoverBg : "transparent"

    Behavior on color { ColorAnimation { duration: Data.Settings.animFast } }

    RowLayout {
        id: iconRow
        anchors.centerIn: parent
        spacing: 6

        Item {
            visible: root.glyph.length > 0
            Layout.preferredWidth: Data.Settings.iconMd
            Layout.preferredHeight: Data.Settings.iconMd

            GlyphIcon {
                anchors.fill: parent
                name: root.glyph
                color: root.selected
                    ? root.accent
                    : iconMouse.containsMouse
                        ? Data.Settings.fgColor
                        : Data.Settings.fgDim
                strokeWidth: 1.75
                opacity: root.enabled ? (root.selected ? 1 : 0.76) : 0.28
            }

            Rectangle {
                visible: root.unread
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: -3
                anchors.rightMargin: -3
                width: 6
                height: 6
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
