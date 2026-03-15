import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "root:/data" as Data

Row {
    id: sysTrayRow
    spacing: 4

    property int itemCount: trayRepeater.count

    Repeater {
        id: trayRepeater
        model: SystemTray.items

        Image {
            required property SystemTrayItem modelData
            source: modelData.icon
            width: 18
            height: 18
            sourceSize: Qt.size(18, 18)

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate()
                    } else {
                        modelData.display()
                    }
                }
            }
        }
    }
}
