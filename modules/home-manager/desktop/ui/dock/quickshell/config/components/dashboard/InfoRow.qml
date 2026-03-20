import QtQuick
import QtQuick.Layouts
import "root:/data" as Data

RowLayout {
    property color dotColor: "white"
    property string text: ""

    spacing: Data.Settings.spacingSm

    Rectangle {
        Layout.preferredWidth: 6
        Layout.preferredHeight: 6
        radius: 3
        color: parent.dotColor
    }

    Text {
        Layout.fillWidth: true
        text: parent.text
        color: Data.Settings.fgColor
        font.pixelSize: Data.Settings.fontBase
        elide: Text.ElideRight
        maximumLineCount: 1
    }
}
