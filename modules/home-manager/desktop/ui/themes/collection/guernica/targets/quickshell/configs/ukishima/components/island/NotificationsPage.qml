import QtQuick
import QtQuick.Layouts

import "root:/components/notifications" as NotificationComponents
import "root:/data" as Data
import "root:/services" as Services

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingMd

        RowLayout {
            Layout.fillWidth: true
            spacing: Data.Settings.spacingSm

            ColumnLayout {
                spacing: 1

                Text {
                    text: "Notifications"
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontLg
                    font.weight: Font.DemiBold
                }

                Text {
                    text: Services.Notifications.count + " saved"
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontXs
                }
            }

            Item { Layout.fillWidth: true }

            HeaderAction {
                label: Services.Notifications.dnd ? "Resume alerts" : "Do not disturb"
                accent: Services.Notifications.dnd
                    ? Data.Settings.purpleColor
                    : Data.Settings.fgDim
                onTriggered: Services.Notifications.toggleDnd()
            }

            HeaderAction {
                label: "Clear"
                accent: Data.Settings.errorColor
                enabled: Services.Notifications.count > 0
                onTriggered: Services.Notifications.clearAll()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Data.Settings.rounding
            color: Data.Settings.bgLightTranslucent
            border.width: 1
            border.color: Data.Settings.borderSubtle
            clip: true

            ListView {
                id: notificationList

                anchors.fill: parent
                anchors.margins: Data.Settings.spacingMd
                model: Services.Notifications.historyModel
                spacing: Data.Settings.notificationGap
                clip: true

                delegate: NotificationComponents.NotificationCard {
                    required property var modelData

                    width: notificationList.width
                    notification: modelData
                    compact: true
                }
            }

            Column {
                anchors.centerIn: parent
                visible: Services.Notifications.count === 0
                spacing: Data.Settings.spacingSm

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "✓"
                    color: Data.Settings.successColor
                    font.pixelSize: Data.Settings.fontXxl
                    font.weight: Font.Bold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Data.Settings.notificationsEnabled
                        ? "All caught up"
                        : "Mako owns notifications"
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontBase
                }
            }
        }
    }

    component HeaderAction: Rectangle {
        required property string label
        property color accent: Data.Settings.accentColor
        signal triggered()

        implicitWidth: actionLabel.implicitWidth + Data.Settings.spacingXl
        implicitHeight: 30
        radius: 15
        color: actionMouse.containsMouse && enabled
            ? Qt.alpha(accent, 0.18)
            : Data.Settings.bgLight
        border.width: 1
        border.color: enabled
            ? Qt.alpha(accent, 0.26)
            : Data.Settings.borderSubtle
        opacity: enabled ? 1.0 : 0.45

        Text {
            id: actionLabel
            anchors.centerIn: parent
            text: parent.label
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontSm
            font.weight: Font.DemiBold
        }

        MouseArea {
            id: actionMouse
            anchors.fill: parent
            enabled: parent.enabled
            hoverEnabled: enabled
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: parent.triggered()
        }
    }
}
