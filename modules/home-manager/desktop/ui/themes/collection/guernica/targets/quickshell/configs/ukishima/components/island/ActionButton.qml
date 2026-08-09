import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data

Rectangle {
    id: root

    required property string label
    required property string icon
    property string detail: ""
    property color accent: Data.Settings.accentColor

    signal triggered()

    implicitHeight: 78
    radius: Data.Settings.rounding
    color: actionMouse.containsMouse
        ? Qt.alpha(accent, 0.17)
        : Data.Settings.bgLight
    border.width: 1
    border.color: actionMouse.containsMouse
        ? Qt.alpha(accent, 0.46)
        : Data.Settings.borderSubtle
    scale: actionMouse.pressed ? 0.98 : 1.0

    Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
    Behavior on border.color { ColorAnimation { duration: Data.Settings.animShort } }
    Behavior on scale { NumberAnimation { duration: Data.Settings.animFast } }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingMd
        spacing: Data.Settings.spacingMd

        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 20
            color: Qt.alpha(root.accent, 0.16)

            Image {
                anchors.centerIn: parent
                source: Quickshell.iconPath(root.icon)
                sourceSize: Qt.size(Data.Settings.iconLg, Data.Settings.iconLg)
                width: Data.Settings.iconLg
                height: Data.Settings.iconLg
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: root.label
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontBase
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: root.detail
                color: Data.Settings.fgDim
                font.pixelSize: Data.Settings.fontXs
                elide: Text.ElideRight
            }
        }
    }

    MouseArea {
        id: actionMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
