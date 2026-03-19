import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Row {
    id: root

    spacing: 4

    property int itemCount: repeater.count

    Repeater {
        id: repeater
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
                onClicked: mouse => mouse.button === Qt.LeftButton ? modelData.activate() : modelData.display()
            }
        }
    }
}
