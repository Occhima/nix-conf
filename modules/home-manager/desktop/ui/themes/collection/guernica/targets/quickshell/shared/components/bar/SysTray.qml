import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "root:/data" as Data

Row {
    id: root

    spacing: Data.Settings.spacingXs

    property int itemCount: repeater.count

    Repeater {
        id: repeater
        model: SystemTray.items

        Image {
            required property SystemTrayItem modelData

            source: modelData.icon
            width: Data.Settings.iconLg
            height: Data.Settings.iconLg
            sourceSize: Qt.size(Data.Settings.iconLg, Data.Settings.iconLg)

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => mouse.button === Qt.LeftButton ? modelData.activate() : modelData.display()
            }
        }
    }
}
