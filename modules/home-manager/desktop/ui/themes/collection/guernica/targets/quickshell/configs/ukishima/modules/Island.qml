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

        PanelWindow {
            required property var modelData

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: Data.Settings.islandDockHeight + Data.Settings.islandMargin
            aboveWindows: true

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: exclusiveZone
            mask: emptyReserveRegion

            Region { id: emptyReserveRegion }

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "guernica-ukishima-reserve"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: islandWindow

            required property var modelData

            readonly property bool surfaceOpen: Data.Runtime.surfaceOpen
            readonly property bool searchSurface: Data.Runtime.activePage === "launcher"
                || Data.Runtime.activePage === "clipboard"
            readonly property bool dockExpanded: dockHover.hovered || surfaceOpen
            readonly property real availableWidth: Math.max(
                320,
                (screen?.width ?? 1920) - Data.Settings.spacingXxl * 2
            )

            function surfaceWidth(page): real {
                switch (page) {
                case "launcher": return Data.Settings.launcherWidth
                case "clipboard": return Data.Settings.clipboardWidth
                case "bluetooth": return Data.Settings.bluetoothWidth
                case "mixer": return Data.Settings.mixerWidth
                case "calendar": return Data.Settings.calendarWidth
                case "media": return Data.Settings.mediaWidth
                case "network": return Data.Settings.networkWidth
                case "notifications": return Data.Settings.notificationsWidth
                case "power": return Data.Settings.powerWidth
                default: return Data.Settings.systemWidth
                }
            }

            function surfaceHeight(page): real {
                switch (page) {
                case "launcher": return Data.Settings.launcherHeight
                case "clipboard": return Data.Settings.clipboardHeight
                case "bluetooth": return Data.Settings.bluetoothHeight
                case "mixer": return Data.Settings.mixerHeight
                case "calendar": return Data.Settings.calendarHeight
                case "media": return Data.Settings.mediaHeight
                case "network": return Data.Settings.networkHeight
                case "notifications": return Data.Settings.notificationsHeight
                case "power": return Data.Settings.powerHeight
                default: return Data.Settings.systemHeight
                }
            }

            function surfaceTitle(page): string {
                switch (page) {
                case "bluetooth": return "Bluetooth"
                case "mixer": return "Mixer"
                case "calendar": return "Weather / Calendar"
                case "media": return "Media"
                case "network": return "Network"
                case "notifications": return "Notifications"
                case "power": return "Power"
                default: return "System"
                }
            }

            function surfaceGlyph(page): string {
                switch (page) {
                case "bluetooth": return "bluetooth"
                case "mixer": return "mixer"
                case "calendar": return Services.Weather.glyph
                case "media": return "music"
                case "network": return Services.Networking.ethernetConnected ? "ethernet" : "wifi"
                case "notifications": return "bell"
                case "power": return "power"
                default: return "monitor"
                }
            }

            readonly property real targetWidth: Math.min(
                availableWidth,
                surfaceOpen
                    ? surfaceWidth(Data.Runtime.activePage)
                    : dockRow.implicitWidth + Data.Settings.islandDockPadding * 2
            )
            readonly property real targetHeight: surfaceOpen
                ? surfaceHeight(Data.Runtime.activePage)
                : Data.Settings.islandDockHeight

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            mask: surfaceOpen ? fullRegion : dockRegion

            BackgroundEffect.blurRegion: Region {
                item: island
                radius: island.radius
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "guernica-ukishima"
            WlrLayershell.keyboardFocus: surfaceOpen
                ? WlrKeyboardFocus.Exclusive
                : WlrKeyboardFocus.None

            Region {
                id: dockRegion
                x: island.x - 8
                y: island.y
                width: island.width + 24
                height: island.height
            }

            Region {
                id: fullRegion
                width: islandWindow.width
                height: islandWindow.height
            }

            onSurfaceOpenChanged: {
                if (surfaceOpen)
                    focusScope.forceActiveFocus()
            }

            FocusScope {
                id: focusScope

                anchors.fill: parent
                focus: islandWindow.surfaceOpen

                Keys.onEscapePressed: Data.Runtime.closeAll()

                MouseArea {
                    anchors.fill: parent
                    enabled: islandWindow.surfaceOpen
                    acceptedButtons: Qt.AllButtons
                    onPressed: mouse => {
                        const inside = mouse.x >= island.x
                            && mouse.x <= island.x + island.width
                            && mouse.y >= island.y
                            && mouse.y <= island.y + island.height
                        if (!inside)
                            Data.Runtime.closeAll()
                    }
                }

                Rectangle {
                    id: island

                    anchors.top: parent.top
                    anchors.topMargin: Data.Settings.islandMargin
                    anchors.horizontalCenter: parent.horizontalCenter

                    width: islandWindow.targetWidth
                    height: islandWindow.targetHeight
                    radius: islandWindow.surfaceOpen
                        ? Data.Settings.popupRadius
                        : Data.Settings.islandDockRadius
                    clip: true
                    border.width: 1
                    border.color: islandWindow.surfaceOpen
                        ? Qt.alpha(Data.Settings.warmAccent, 0.28)
                        : Data.Settings.glassEdge
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: islandWindow.surfaceOpen
                                ? Data.Settings.surfaceTopOpen
                                : Data.Settings.surfaceTop
                        }
                        GradientStop {
                            position: 1
                            color: islandWindow.surfaceOpen
                                ? Data.Settings.surfaceBottomOpen
                                : Data.Settings.surfaceBottom
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: Data.Settings.animMorph
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: Data.Settings.animMorph
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on radius {
                        NumberAnimation {
                            duration: Data.Settings.animMorph
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation { duration: Data.Settings.animShort }
                    }

                    HoverHandler {
                        id: dockHover
                        enabled: !islandWindow.surfaceOpen
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: parent.radius
                        anchors.rightMargin: parent.radius
                        height: 1
                        color: Data.Settings.glassSpecular
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: parent.radius
                        anchors.rightMargin: parent.radius
                        height: 1
                        color: Qt.rgba(0, 0, 0, 0.22)
                    }

                    Item {
                        anchors.fill: parent
                        enabled: !islandWindow.surfaceOpen
                        opacity: enabled ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: Data.Settings.animFast }
                        }

                        Row {
                            id: dockRow

                            anchors.centerIn: parent
                            spacing: 11

                            IslandComponents.WorkspaceStrip {
                                anchors.verticalCenter: parent.verticalCenter
                                screen: islandWindow.screen
                            }

                            DockDivider {}

                            Item {
                                anchors.verticalCenter: parent.verticalCenter
                                width: clockColumn.implicitWidth
                                height: clockColumn.implicitHeight

                                Column {
                                    id: clockColumn

                                    anchors.centerIn: parent
                                    spacing: -1

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Data.Time.time
                                        color: Data.Settings.fgColor
                                        font.family: "monospace"
                                        font.pixelSize: Data.Settings.fontBase
                                        font.weight: Font.DemiBold
                                    }
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Data.Time.barDate.toUpperCase()
                                        color: Data.Settings.fgDim
                                        font.family: "monospace"
                                        font.pixelSize: Data.Settings.fontXs
                                        font.letterSpacing: 1.1
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -5
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Data.Runtime.togglePage("calendar")
                                }
                            }

                            Item {
                                id: expandedSlot

                                anchors.verticalCenter: parent.verticalCenter
                                visible: islandWindow.dockExpanded
                                implicitWidth: expandedRow.implicitWidth
                                implicitHeight: expandedRow.implicitHeight

                                Row {
                                    id: expandedRow

                                    anchors.centerIn: parent
                                    spacing: 11

                                    DockDivider {}

                                    IslandComponents.PillIcon {
                                        glyph: "search"
                                        onTriggered: Data.Runtime.togglePage("launcher")
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: Services.Weather.glyph
                                        text: Services.Weather.temperature
                                        onTriggered: Data.Runtime.togglePage("calendar")
                                    }

                                    Bar.SysTray {
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: itemCount > 0
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: Services.Networking.ethernetConnected ? "ethernet" : "wifi"
                                        selected: Services.Networking.connected
                                        onTriggered: Data.Runtime.togglePage("network")
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: "bluetooth"
                                        selected: Services.Bluetooth.connected
                                        onTriggered: Data.Runtime.togglePage("bluetooth")
                                    }

                                    IslandComponents.PillIcon {
                                        visible: Services.UPower.hasBattery
                                        glyph: "battery"
                                        text: Math.round(Services.UPower.percentage) + "%"
                                        selected: Services.UPower.charging
                                        onTriggered: Data.Runtime.togglePage("system")
                                    }

                                    IslandComponents.PillIcon {
                                        visible: Data.Settings.notificationsEnabled
                                        glyph: "bell"
                                        unread: Services.Notifications.count > 0
                                        onTriggered: Data.Runtime.togglePage("notifications")
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: "mixer"
                                        selected: Services.Pipewire.muted
                                        onTriggered: Data.Runtime.togglePage("mixer")
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: "monitor"
                                        onTriggered: Data.Runtime.togglePage("system")
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: "music"
                                        onTriggered: Data.Runtime.togglePage("media")
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: "clipboard"
                                        onTriggered: Data.Runtime.togglePage("clipboard")
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: "image"
                                        onTriggered: Quickshell.execDetached([
                                            "xdg-open",
                                            Quickshell.env("HOME") + "/Pictures"
                                        ])
                                    }

                                    IslandComponents.PillIcon {
                                        glyph: "power"
                                        onTriggered: Data.Runtime.togglePage("power")
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        id: surfacePanel

                        anchors.fill: parent
                        enabled: islandWindow.surfaceOpen
                        opacity: enabled ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: Data.Settings.animShort }
                        }

                        RowLayout {
                            id: surfaceHeader

                            visible: !islandWindow.searchSurface
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 10
                            anchors.leftMargin: 14
                            anchors.rightMargin: 10
                            height: visible ? 28 : 0
                            spacing: 7

                            IslandComponents.GlyphIcon {
                                Layout.preferredWidth: Data.Settings.iconMd
                                Layout.preferredHeight: Data.Settings.iconMd
                                name: islandWindow.surfaceGlyph(Data.Runtime.activePage)
                                color: Data.Settings.warmAccent
                                strokeWidth: 2
                            }

                            Text {
                                text: islandWindow.surfaceTitle(Data.Runtime.activePage).toUpperCase()
                                color: Data.Settings.fgDim
                                font.family: "monospace"
                                font.pixelSize: Data.Settings.fontXs
                                font.weight: Font.DemiBold
                                font.letterSpacing: 1.4
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                visible: Data.Runtime.activePage === "system"
                                text: "UP " + Services.SystemInfo.uptime.toUpperCase()
                                color: Data.Settings.fgDim
                                font.family: "monospace"
                                font.pixelSize: Data.Settings.fontXs
                            }

                            Rectangle {
                                Layout.preferredWidth: 22
                                Layout.preferredHeight: 22
                                radius: 5
                                color: closeMouse.containsMouse
                                    ? Data.Settings.hoverBg
                                    : "transparent"

                                IslandComponents.GlyphIcon {
                                    anchors.centerIn: parent
                                    width: Data.Settings.iconSm
                                    height: Data.Settings.iconSm
                                    name: "close"
                                    color: Data.Settings.fgDim
                                    strokeWidth: 1.9
                                }

                                MouseArea {
                                    id: closeMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Data.Runtime.closeAll()
                                }
                            }
                        }

                        Rectangle {
                            visible: !islandWindow.searchSurface
                            anchors.top: surfaceHeader.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 5
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            height: 1
                            color: Data.Settings.hairline
                        }

                        Loader {
                            anchors.fill: parent
                            anchors.topMargin: islandWindow.searchSurface ? 11 : 50
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            anchors.bottomMargin: 12
                            active: islandWindow.surfaceOpen
                            sourceComponent: {
                                switch (Data.Runtime.activePage) {
                                case "launcher": return launcherPage
                                case "clipboard": return clipboardPage
                                case "bluetooth": return bluetoothPage
                                case "mixer": return mixerPage
                                case "calendar": return calendarPage
                                case "media": return mediaPage
                                case "network": return connectivityPage
                                case "notifications": return notificationsPage
                                case "power": return powerPage
                                default: return systemPage
                                }
                            }
                        }
                    }
                }

                Item {
                    id: notificationBadge

                    readonly property int count: Data.Settings.notificationsEnabled
                        ? Services.Notifications.count
                        : 0
                    readonly property bool alert: count > 0
                    readonly property bool muted: Services.Notifications.dnd
                    readonly property bool critical: Services.Notifications.hasCritical && !muted
                    readonly property string label: count > 9 ? "9+" : String(count)
                    readonly property string glyph: muted
                        ? "notifications_off"
                        : critical ? "priority_high" : ""
                    readonly property bool glyphMode: glyph.length > 0

                    anchors.left: island.right
                    anchors.leftMargin: 6
                    anchors.verticalCenter: island.verticalCenter

                    implicitWidth: glyphMode
                        ? 18
                        : Math.max(18, badgeLabel.implicitWidth + 12)
                    implicitHeight: 18

                    visible: opacity > 0
                    opacity: (alert && !islandWindow.surfaceOpen) ? 1 : 0
                    scale: (alert && !islandWindow.surfaceOpen) ? 1 : 0.6

                    Behavior on opacity {
                        NumberAnimation { duration: Data.Settings.animShort }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: Data.Settings.animGlide
                            easing.type: Easing.OutBack
                            easing.overshoot: 1.6
                        }
                    }
                    Behavior on implicitWidth {
                        NumberAnimation { duration: Data.Settings.animShort }
                    }

                    Rectangle {
                        id: badgeSurface

                        readonly property color content: notificationBadge.critical
                            ? Data.Settings.bgColor
                            : notificationBadge.muted
                                ? Data.Settings.fgDim
                                : Data.Settings.fgColor

                        anchors.fill: parent
                        radius: height / 2
                        color: notificationBadge.critical
                            ? Data.Settings.fgColor
                            : Data.Settings.bgLighter

                        Behavior on color {
                            ColorAnimation { duration: Data.Settings.animShort }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "transparent"
                            border.width: 1
                            border.color: badgeMouse.containsMouse
                                ? Data.Settings.borderHover
                                : Data.Settings.borderSubtle
                        }

                        Text {
                            id: badgeLabel

                            visible: !notificationBadge.glyphMode
                            anchors.centerIn: parent
                            text: notificationBadge.label
                            color: badgeSurface.content
                            font.family: "monospace"
                            font.pixelSize: Data.Settings.fontXs
                            font.weight: Font.DemiBold
                        }

                        IslandComponents.GlyphIcon {
                            visible: notificationBadge.glyphMode
                            anchors.centerIn: parent
                            width: Data.Settings.iconSm - 4
                            height: Data.Settings.iconSm - 4
                            name: notificationBadge.glyph
                            color: badgeSurface.content
                            strokeWidth: 2.4
                        }
                        SequentialAnimation on opacity {
                            running: notificationBadge.critical
                                && notificationBadge.alert
                                && !islandWindow.surfaceOpen
                            loops: Animation.Infinite
                            alwaysRunToEnd: true

                            NumberAnimation {
                                from: 1
                                to: 0.45
                                duration: 620
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                from: 0.45
                                to: 1
                                duration: 620
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    MouseArea {
                        id: badgeMouse

                        anchors.fill: parent
                        anchors.margins: -5
                        enabled: Data.Settings.notificationsEnabled
                            && notificationBadge.alert
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Data.Runtime.togglePage("notifications")
                    }
                }
            }

            Component { id: launcherPage; IslandComponents.LauncherPage {} }
            Component { id: clipboardPage; IslandComponents.ClipboardPage {} }
            Component { id: bluetoothPage; IslandComponents.BluetoothPage {} }
            Component { id: mixerPage; IslandComponents.MixerPage {} }
            Component { id: calendarPage; IslandComponents.CalendarPage {} }
            Component { id: mediaPage; IslandComponents.MediaPage {} }
            Component { id: connectivityPage; IslandComponents.ConnectivityPage {} }
            Component { id: notificationsPage; IslandComponents.NotificationsPage {} }
            Component { id: powerPage; IslandComponents.PowerPage {} }
            Component { id: systemPage; IslandComponents.SystemPage {} }

            component DockDivider: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1
                height: 22
                color: Data.Settings.hairline
            }
        }
    }
}
