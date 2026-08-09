import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import "root:/components/quicksettings" as QS
import "root:/data" as Data
import "root:/services" as Services

Scope {
    Connections {
        target: Services.Notifications

        function onCountChanged(): void {
            if (Data.Runtime.notificationCenterVisible
                && !Services.Notifications.hasNotifications) {
                Data.Runtime.closeAll()
            }
        }
    }

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            id: notificationCenterWindow

            property var modelData
            readonly property var compositorMonitor: Hyprland.monitorFor(screen)
            readonly property bool focusedOutput: compositorMonitor?.focused
                ?? modelData === Quickshell.screens[0]

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-notification-center"
            exclusiveZone: 0
            visible: Data.Settings.notificationsEnabled
                && Data.Runtime.notificationCenterVisible
                && focusedOutput

            anchors {
                top: true
                right: true
            }

            implicitWidth: Data.Settings.notificationWidth
                + Data.Settings.barSideMargin
                + Data.Settings.spacingXl
            implicitHeight: panel.height + Data.Settings.spacingSm
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: panel

                anchors {
                    top: parent.top
                    topMargin: 4
                    right: parent.right
                    rightMargin: Data.Settings.barSideMargin
                }

                width: Data.Settings.notificationWidth
                height: panelContent.implicitHeight
                    + Data.Settings.notificationPadding * 2
                color: Data.Settings.notificationSurface
                radius: Data.Settings.popupRadius
                border.width: 1
                border.color: Data.Settings.notificationBorder
                clip: true
                transformOrigin: Item.TopRight

                scale: Data.Runtime.notificationCenterVisible
                    ? 1.0
                    : Data.Settings.popupScaleHidden
                opacity: Data.Runtime.notificationCenterVisible ? 1.0 : 0.0

                Behavior on scale {
                    NumberAnimation {
                        duration: Data.Settings.animMedium
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: Data.Settings.animShort }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: function(mouse) { mouse.accepted = true }
                }

                ColumnLayout {
                    id: panelContent

                    anchors {
                        fill: parent
                        margins: Data.Settings.notificationPadding
                    }

                    QS.NotificationList {
                        Layout.fillWidth: true
                        maxListHeight: Math.max(
                            160,
                            Math.min(480, notificationCenterWindow.screen.height - 180)
                        )
                    }
                }
            }
        }
    }
}
