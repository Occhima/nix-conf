import QtQuick
import QtQuick.Layouts

import "root:/data" as Data

Item {
    id: root

    property alias text: queryInput.text
    property string placeholder: "Search"
    property string icon: "search"
    property int resultCount: 0
    property int totalCount: resultCount

    signal moveRequested(int delta)
    signal accepted()

    implicitHeight: 38

    function focusInput(): void {
        queryInput.forceActiveFocus()
        queryInput.selectAll()
    }

    RowLayout {
        anchors.fill: parent
        spacing: 9

        GlyphIcon {
            Layout.preferredWidth: Data.Settings.iconMd
            Layout.preferredHeight: Data.Settings.iconMd
            name: root.icon
            color: Data.Settings.warmAccent
            strokeWidth: 2
        }

        TextInput {
            id: queryInput

            Layout.fillWidth: true
            color: Data.Settings.fgColor
            selectionColor: Qt.alpha(Data.Settings.warmAccent, 0.38)
            selectedTextColor: Data.Settings.fgColor
            font.family: "monospace"
            font.pixelSize: Data.Settings.fontSm
            clip: true

            Text {
                anchors.fill: parent
                visible: queryInput.text.length === 0
                text: root.placeholder
                color: Data.Settings.fgDim
                font: queryInput.font
                verticalAlignment: Text.AlignVCenter
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Up) {
                    root.moveRequested(-1)
                    event.accepted = true
                } else if (event.key === Qt.Key_Down) {
                    root.moveRequested(1)
                    event.accepted = true
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    root.accepted()
                    event.accepted = true
                } else if (event.key === Qt.Key_Escape) {
                    Data.Runtime.closeAll()
                    event.accepted = true
                }
            }
        }

        Text {
            text: root.resultCount + " / " + root.totalCount
            color: Data.Settings.fgDim
            font.family: "monospace"
            font.pixelSize: Data.Settings.fontXs
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Data.Settings.hairline
    }

    Component.onCompleted: root.focusInput()
}
