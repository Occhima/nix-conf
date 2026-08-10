import QtQuick

import "root:/data" as Data

Item {
    id: root

    required property string label
    property string glyph: "●"
    property real value: 0
    property color accent: Data.Settings.warmAccent
    property bool glyphClickable: false

    signal valueEdited(real value)
    signal glyphTriggered()

    implicitWidth: 72
    implicitHeight: 158
    opacity: enabled ? 1 : 0.36

    function requestValue(mouseY: real): void {
        valueEdited(Math.max(0, Math.min(1, 1 - mouseY / slider.height)))
    }

    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: Math.round(Math.max(0, Math.min(1, root.value)) * 100) + "%"
        color: Data.Settings.fgColor
        font.family: "monospace"
        font.pixelSize: Data.Settings.fontSm
        font.weight: Font.DemiBold
    }

    Item {
        id: slider

        anchors.top: parent.top
        anchors.topMargin: 23
        anchors.bottom: glyphLabel.top
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        width: 24

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: Data.Settings.hairline
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: 2
            height: parent.height * Math.max(0, Math.min(1, root.value))
            color: root.accent
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            y: (1 - Math.max(0, Math.min(1, root.value))) * (parent.height - height)
            width: 20
            height: 4
            radius: 2
            color: root.accent

            Behavior on y {
                NumberAnimation {
                    duration: Data.Settings.animFast
                    easing.type: Easing.OutCubic
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            anchors.leftMargin: -12
            anchors.rightMargin: -12
            enabled: root.enabled
            cursorShape: Qt.SizeVerCursor
            onPressed: mouse => root.requestValue(mouse.y)
            onPositionChanged: mouse => {
                if (pressed)
                    root.requestValue(mouse.y)
            }
        }
    }

    Text {
        id: glyphLabel
        anchors.bottom: labelText.top
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.glyph
        color: root.accent
        font.pixelSize: Data.Settings.fontBase

        MouseArea {
            anchors.fill: parent
            anchors.margins: -5
            enabled: root.glyphClickable
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.glyphTriggered()
        }
    }

    Text {
        id: labelText
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.label.toUpperCase()
        color: Data.Settings.fgDim
        font.family: "monospace"
        font.pixelSize: Data.Settings.fontXs
        font.letterSpacing: 1
    }
}
