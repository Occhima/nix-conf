import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../data" as Data

Column {
    spacing: 4

    Repeater {
        model: SystemTray.items

        Image {
            required property SystemTrayItem modelData
            source: modelData.icon
            width: 20
            height: 20
            sourceSize: Qt.size(20, 20)

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate();
                    } else {
                        modelData.display();
                    }
                }
            }
        }
    }
}
