import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/data" as Data

Rectangle {
    id: root

    property string icon
    property string label
    property string subLabel
    property bool active: false
    property color activeColor: Data.Settings.accentColor
    signal clicked()

    height: 64
    radius: 20
    color: active ? activeColor : Data.Settings.bgLight
    scale: toggleMouseArea.pressed ? 0.96 : 1.0

    Behavior on color { ColorAnimation { duration: Data.Settings.animMedium } }
    Behavior on scale { NumberAnimation { duration: Data.Settings.animFast; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: root.active ? Qt.rgba(0, 0, 0, 0.1) : Data.Settings.borderSubtle
        opacity: toggleMouseArea.containsMouse && !toggleMouseArea.pressed ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: Data.Settings.animShort } }
    }

    MouseArea {
        id: toggleMouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: root.clicked()
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Data.Settings.spacingLg
        anchors.rightMargin: Data.Settings.spacingLg
        spacing: Data.Settings.spacingMd

        Rectangle {
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            radius: 18
            color: root.active ? Qt.rgba(1, 1, 1, 0.25) : Data.Settings.bgLighter

            Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }

            Image {
                anchors.centerIn: parent
                source: Quickshell.iconPath(root.icon)
                width: Data.Settings.iconLg
                height: Data.Settings.iconLg
                sourceSize: Qt.size(Data.Settings.iconLg, Data.Settings.iconLg)
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.label
                font.pixelSize: Data.Settings.fontBase
                font.weight: Font.DemiBold
                color: root.active ? Data.Settings.bgColor : Data.Settings.fgColor
                elide: Text.ElideRight
                Layout.fillWidth: true

                Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
            }

            Text {
                text: root.subLabel
                font.pixelSize: Data.Settings.fontSm
                color: root.active ? Qt.rgba(0, 0, 0, 0.6) : Data.Settings.fgDim
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: text !== ""

                Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }
            }
        }
    }
}
