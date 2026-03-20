import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/data" as Data

ColumnLayout {
    id: root

    property string icon
    property string label
    property real value: 0
    property bool enabled: true
    property color accentColor: Data.Settings.accentColor
    signal sliderMoved(real newVal)

    spacing: Data.Settings.spacingSm
    opacity: enabled ? 1.0 : 0.5

    RowLayout {
        Layout.fillWidth: true
        spacing: Data.Settings.spacingSm

        Image {
            source: Quickshell.iconPath(root.icon)
            width: Data.Settings.iconLg
            height: Data.Settings.iconLg
            sourceSize: Qt.size(Data.Settings.iconLg, Data.Settings.iconLg)
        }

        Text {
            text: root.label
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontBase
            font.weight: Font.Medium
        }

        Item { Layout.fillWidth: true }

        Text {
            text: root.enabled ? Math.round(root.value * 100) + "%" : "--%"
            color: Data.Settings.fgDim
            font.pixelSize: 12
            font.weight: Font.Bold
        }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 8
        radius: 4
        color: Data.Settings.bgLighter

        Rectangle {
            width: parent.width * Math.min(1, root.value)
            height: parent.height
            radius: parent.radius
            color: root.accentColor

            Behavior on width {
                NumberAnimation { duration: Data.Settings.animFast; easing.type: Easing.OutCubic }
            }
        }

        Rectangle {
            x: parent.width * Math.min(1, root.value) - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 16
            radius: 8
            color: Data.Settings.fgColor
            visible: root.enabled && (sliderMouseArea.containsMouse || sliderMouseArea.pressed)

            Behavior on x { NumberAnimation { duration: 50 } }
        }

        MouseArea {
            id: sliderMouseArea
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: root.enabled
            enabled: root.enabled
            onClicked: mouse => root.sliderMoved(Math.max(0, Math.min(1, mouse.x / parent.width)))
            onPositionChanged: mouse => {
                if (pressed) root.sliderMoved(Math.max(0, Math.min(1, mouse.x / parent.width)))
            }
        }
    }
}
