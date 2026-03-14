import QtQuick
import "../data" as Data

Text {
    text: Data.Time.time
    color: Data.Settings.fgColor
    font.pixelSize: 13
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
    lineHeight: 1.1
}
