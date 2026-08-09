import QtQuick
import QtQuick.Layouts

import "root:/components/notifications" as NotificationComponents
import "root:/data" as Data
import "root:/services" as Services

ColumnLayout {
    id: root

    property int maxListHeight: 220

    spacing: Data.Settings.spacingMd

    RowLayout {
        Layout.fillWidth: true

        Text {
            text: "Notifications"
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontBase
            font.weight: Font.DemiBold
        }

        Rectangle {
            Layout.preferredWidth: countLabel.implicitWidth + Data.Settings.spacingMd
            Layout.preferredHeight: 22
            radius: 11
            color: Data.Settings.bgLighter
            visible: Services.Notifications.count > 0

            Text {
                id: countLabel

                anchors.centerIn: parent
                text: Services.Notifications.count
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontXs
                font.weight: Font.Bold
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: "Clear"
            color: clearMouse.containsMouse
                ? Data.Settings.fgColor
                : Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontSm
            visible: Services.Notifications.count > 0

            MouseArea {
                id: clearMouse

                anchors.fill: parent
                anchors.margins: -Data.Settings.spacingSm
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Services.Notifications.clearAll()
            }
        }
    }

    Text {
        Layout.fillWidth: true
        text: Services.Notifications.dnd
            ? "Do not disturb is on"
            : "You're all caught up"
        color: Data.Settings.fgDim
        font.pixelSize: Data.Settings.fontSm
        horizontalAlignment: Text.AlignHCenter
        visible: Services.Notifications.count === 0
    }

    ListView {
        id: historyView

        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(contentHeight, root.maxListHeight)
        model: Services.Notifications.historyModel
        spacing: Data.Settings.spacingSm
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        visible: Services.Notifications.count > 0

        delegate: NotificationComponents.NotificationCard {
            required property var modelData

            width: historyView.width
            notification: modelData
            compact: true
        }
    }
}
