import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import "root:/components/notifications" as NotificationComponents
import "root:/data" as Data
import "root:/services" as Services

Scope {
    Variants {
        model: Quickshell.screens

        WlrLayershell {
            id: notificationWindow

            property var modelData
            readonly property var compositorMonitor: Hyprland.monitorFor(screen)
            readonly property bool focusedOutput: compositorMonitor?.focused
                ?? modelData === Quickshell.screens[0]

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-notifications"
            exclusiveZone: 0
            visible: Data.Settings.notificationsEnabled
                && focusedOutput
                && Services.Notifications.toasts.length > 0

            anchors {
                top: true
                right: true
            }

            implicitWidth: Data.Settings.notificationWidth
                + Data.Settings.barSideMargin
            implicitHeight: toastColumn.implicitHeight
                + Data.Settings.barHeight
                + Data.Settings.barMargin * 2
                + Data.Settings.notificationGap
            color: "transparent"

            Column {
                id: toastColumn

                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight
                        + Data.Settings.barMargin * 2
                        + Data.Settings.notificationGap
                    right: parent.right
                    rightMargin: Data.Settings.barSideMargin
                }
                width: Data.Settings.notificationWidth
                spacing: Data.Settings.notificationGap

                Repeater {
                    model: Services.Notifications.toastModel

                    delegate: NotificationComponents.NotificationCard {
                        required property var modelData

                        width: toastColumn.width
                        notification: modelData
                        autoExpire: true
                    }
                }
            }
        }
    }
}
