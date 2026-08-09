import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/components/bar" as Bar
import "root:/components/island" as IslandComponents
import "root:/data" as Data
import "root:/services" as Services

Scope {
    Variants {
        model: Quickshell.screens

        WlrLayershell {
            id: islandWindow

            property var modelData
            property bool hoverExpanded: false
            readonly property bool expanded: hoverExpanded || Data.Runtime.expanded

            screen: modelData
            layer: WlrLayer.Top
            namespace: "guernica-ukishima"
            exclusiveZone: Data.Settings.islandCollapsedHeight + Data.Settings.islandMargin

            anchors { top: true }

            implicitWidth: island.width
            implicitHeight: island.height + Data.Settings.islandMargin
            color: "transparent"

            Rectangle {
                id: island

                anchors.top: parent.top
                anchors.topMargin: Data.Settings.islandMargin
                anchors.horizontalCenter: parent.horizontalCenter

                width: islandWindow.expanded
                    ? Math.min(
                        Data.Settings.islandExpandedWidth,
                        (islandWindow.screen?.width ?? Data.Settings.islandExpandedWidth)
                            - Data.Settings.spacingXl
                    )
                    : Data.Settings.islandCollapsedWidth
                height: islandWindow.expanded
                    ? Data.Settings.islandExpandedHeight
                    : Data.Settings.islandCollapsedHeight
                radius: islandWindow.expanded
                    ? Data.Settings.popupRadius
                    : height / 2
                clip: true
                color: Data.Settings.bgColorTranslucent
                border.width: 1
                border.color: islandWindow.expanded
                    ? Qt.alpha(Data.Settings.accentColor, 0.34)
                    : Data.Settings.borderNormal

                Behavior on width {
                    NumberAnimation {
                        duration: Data.Settings.animMorph
                        easing.type: Easing.OutExpo
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: Data.Settings.animMorph
                        easing.type: Easing.OutExpo
                    }
                }

                Behavior on radius {
                    NumberAnimation {
                        duration: Data.Settings.animMedium
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on border.color {
                    ColorAnimation { duration: Data.Settings.animShort }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: islandWindow.expanded ? 118 : 72
                    height: 3
                    radius: 2
                    color: Data.Settings.warmAccent

                    Behavior on width {
                        NumberAnimation {
                            duration: Data.Settings.animMorph
                            easing.type: Easing.OutExpo
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: Qt.alpha(Data.Settings.fgColor, 0.045)
                        }
                        GradientStop {
                            position: 0.42
                            color: "transparent"
                        }
                    }
                }

                MouseArea {
                    id: islandMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton

                    onEntered: islandWindow.hoverExpanded = true
                    onExited: islandWindow.hoverExpanded = false
                    onClicked: {
                        if (!Data.Runtime.expanded) {
                            Data.Runtime.activePage = "dashboard"
                            Data.Runtime.expanded = true
                        }
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: islandWindow.expanded ? Data.Settings.spacingSm : 0

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 28

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Data.Settings.spacingSm
                            anchors.rightMargin: Data.Settings.spacingSm
                            spacing: Data.Settings.spacingSm

                            Bar.Workspaces {
                                screen: islandWindow.screen
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: Data.Time.time
                                color: Data.Settings.fgColor
                                font.pixelSize: Data.Settings.fontBase
                                font.weight: Font.Bold
                            }

                            Item { Layout.fillWidth: true }

                            IslandComponents.StatusChip {
                                icon: Services.Networking.icon
                                text: islandWindow.expanded
                                    ? Services.Networking.statusText
                                    : ""
                                accent: Services.Networking.connected
                                    ? Data.Settings.successColor
                                    : Data.Settings.warningColor
                                onTriggered: Data.Runtime.togglePage("network")
                            }

                            IslandComponents.StatusChip {
                                visible: Services.UPower.hasBattery
                                icon: Services.UPower.icon
                                text: Math.round(Services.UPower.percentage) + "%"
                                accent: Services.UPower.charging
                                    ? Data.Settings.successColor
                                    : Data.Settings.accentColor
                            }

                            IslandComponents.StatusChip {
                                visible: Data.Settings.notificationsEnabled
                                icon: Services.Notifications.icon
                                text: Services.Notifications.count > 0
                                    ? String(Services.Notifications.count)
                                    : ""
                                accent: Services.Notifications.count > 0
                                    ? Data.Settings.errorColor
                                    : Data.Settings.fgDim
                                onTriggered: Data.Runtime.togglePage("notifications")
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: islandWindow.expanded ? 1 : 0
                        visible: islandWindow.expanded
                        color: Data.Settings.borderSubtle
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: islandWindow.expanded ? 34 : 0
                        visible: islandWindow.expanded
                        spacing: Data.Settings.spacingXs

                        Repeater {
                            model: [
                                { page: "dashboard", label: "Home", icon: "view-grid-symbolic" },
                                { page: "media", label: "Media", icon: "audio-x-generic-symbolic" },
                                { page: "network", label: "Links", icon: "network-wireless-symbolic" },
                                { page: "notifications", label: "Alerts", icon: "preferences-system-notifications-symbolic" },
                                { page: "power", label: "Power", icon: "system-shutdown-symbolic" }
                            ]

                            IslandComponents.PageButton {
                                required property var modelData

                                Layout.fillWidth: true
                                page: modelData.page
                                label: modelData.label
                                icon: modelData.icon
                                onTriggered: {
                                    Data.Runtime.activePage = page
                                    Data.Runtime.expanded = true
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: islandWindow.expanded ? 1 : 0
                        visible: islandWindow.expanded
                        color: Data.Settings.borderSubtle
                    }

                    Loader {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: Data.Settings.spacingSm
                        visible: islandWindow.expanded
                        active: visible
                        opacity: visible ? 1.0 : 0.0
                        sourceComponent: {
                            switch (Data.Runtime.activePage) {
                            case "media": return mediaPage
                            case "network": return connectivityPage
                            case "notifications": return notificationsPage
                            case "power": return powerPage
                            default: return dashboardPage
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation { duration: Data.Settings.animShort }
                        }
                    }
                }
            }

            Component { id: dashboardPage; IslandComponents.DashboardPage {} }
            Component { id: mediaPage; IslandComponents.MediaPage {} }
            Component { id: connectivityPage; IslandComponents.ConnectivityPage {} }
            Component { id: notificationsPage; IslandComponents.NotificationsPage {} }
            Component { id: powerPage; IslandComponents.PowerPage {} }
        }
    }
}
