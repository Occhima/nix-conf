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

        // Keep workspace reservation independent from the morphing surface.
        // Resizing the layer-shell window together with the pill makes the
        // compositor recalculate its position on every animation frame.
        PanelWindow {
            id: reserveWindow

            required property var modelData

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: Data.Settings.islandRestHeight + Data.Settings.islandMargin
            aboveWindows: true

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: exclusiveZone

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "guernica-ukishima-reserve"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            // The reserve window only contributes an exclusive zone. It must
            // never take pointer input from applications below it.
            mask: emptyReserveRegion
            Region { id: emptyReserveRegion }
        }
    }

    Variants {
        model: Quickshell.screens

        // The overlay never changes size. Only the pill inside it morphs, and
        // the input mask follows both the current and target pill geometry.
        PanelWindow {
            id: islandWindow

            required property var modelData
            property bool pointerInside: false
            property bool hoverLatch: false
            property string previousMode: "rest"
            property bool hoverHop: false

            readonly property bool surfaceOpen: Data.Runtime.surfaceOpen
            readonly property bool hoverOpen: !surfaceOpen && hoverLatch
            readonly property string mode: surfaceOpen ? "surface" : (hoverOpen ? "hover" : "rest")
            readonly property real availableWidth: Math.max(
                240,
                (screen?.width ?? 1920) - Data.Settings.spacingXxl * 2
            )
            function surfaceWidth(page) {
                switch (page) {
                case "calendar": return Data.Settings.calendarWidth
                case "media": return Data.Settings.mediaWidth
                case "network": return Data.Settings.networkWidth
                case "notifications": return Data.Settings.notificationsWidth
                case "power": return Data.Settings.powerWidth
                default: return Data.Settings.systemWidth
                }
            }

            function surfaceHeight(page) {
                switch (page) {
                case "calendar": return Data.Settings.calendarHeight
                case "media": return Data.Settings.mediaHeight
                case "network": return Data.Settings.networkHeight
                case "notifications": return Data.Settings.notificationsHeight
                case "power": return Data.Settings.powerHeight
                default: return Data.Settings.systemHeight
                }
            }

            function surfaceTitle(page) {
                switch (page) {
                case "calendar": return "Calendar"
                case "media": return "Media"
                case "network": return "Links"
                case "notifications": return "Alerts"
                case "power": return "Power"
                default: return "System"
                }
            }

            function surfaceGlyph(page) {
                switch (page) {
                case "calendar": return "暦"
                case "media": return "音"
                case "network": return "網"
                case "notifications": return "告"
                case "power": return "電"
                default: return "系"
                }
            }

            readonly property real targetWidth: Math.min(
                availableWidth,
                surfaceOpen
                    ? surfaceWidth(Data.Runtime.activePage)
                    : hoverOpen
                        ? hoverRow.implicitWidth + Data.Settings.islandHoverPadding * 2
                        : Data.Settings.islandRestWidth
            )
            readonly property real targetHeight: surfaceOpen
                ? surfaceHeight(Data.Runtime.activePage)
                : hoverOpen
                    ? Data.Settings.islandHoverHeight
                    : Data.Settings.islandRestHeight
            readonly property real morphCloseness: {
                const distance = Math.max(
                    Math.abs(island.width - targetWidth),
                    Math.abs(island.height - targetHeight)
                )
                return 1 - Math.min(1, distance / 110)
            }

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "guernica-ukishima"
            WlrLayershell.keyboardFocus: surfaceOpen
                ? WlrKeyboardFocus.Exclusive
                : WlrKeyboardFocus.None

            mask: surfaceOpen ? fullRegion : pillRegion

            // Using max(current, target) prevents the pointer from falling out
            // of the mask while the pill grows or shrinks.
            Region {
                id: pillRegion

                readonly property real baseWidth: Math.max(island.width, islandWindow.targetWidth)

                x: island.x + (island.width - baseWidth) / 2
                y: island.y
                width: baseWidth + 12
                height: Math.max(island.height, islandWindow.targetHeight)
            }

            Region {
                id: fullRegion
                width: islandWindow.width
                height: islandWindow.height
            }

            onPointerInsideChanged: {
                if (pointerInside) {
                    hoverLatch = true
                    hoverGrace.stop()
                } else {
                    hoverGrace.restart()
                }
            }

            onModeChanged: {
                hoverHop = (previousMode === "rest" && mode === "hover")
                    || (previousMode === "hover" && mode === "rest")
                previousMode = mode
            }

            onSurfaceOpenChanged: {
                if (surfaceOpen) {
                    focusScope.forceActiveFocus()
                    pointerInside = false
                    hoverLatch = false
                    hoverGrace.stop()
                }
            }

            Timer {
                id: hoverGrace

                interval: Data.Settings.animHoverGrace
                repeat: false
                onTriggered: {
                    if (islandWindow.pointerInside)
                        return
                    if (islandWindow.morphCloseness < 0.95) {
                        restart()
                        return
                    }
                    islandWindow.hoverLatch = false
                }
            }

            FocusScope {
                id: focusScope

                anchors.fill: parent
                focus: islandWindow.surfaceOpen

                // This handler belongs to the stable window, not to the item
                // whose geometry is animated. The window mask limits it to the
                // pill when no surface is open.
                HoverHandler {
                    enabled: !islandWindow.surfaceOpen
                    onHoveredChanged: {
                        if (enabled)
                            islandWindow.pointerInside = hovered
                    }
                }

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
                        : height / 2
                    // The hover soul bead sits just outside the pill edge. Open
                    // surfaces still clip their scrolling/content faces.
                    clip: islandWindow.surfaceOpen
                    border.width: 1
                    border.color: islandWindow.surfaceOpen
                        ? Qt.alpha(Data.Settings.accentColor, 0.26)
                        : Data.Settings.borderNormal
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: Data.Settings.surfaceTop
                        }
                        GradientStop {
                            position: 1
                            color: Data.Settings.surfaceBottom
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: islandWindow.hoverHop
                                ? Data.Settings.animGlide
                                : Data.Settings.animMorph
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: [0.16, 1, 0.3, 1, 1, 1]
                        }
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: islandWindow.hoverHop
                                ? Data.Settings.animGlide
                                : Data.Settings.animMorph
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: [0.16, 1, 0.3, 1, 1, 1]
                        }
                    }
                    Behavior on radius {
                        NumberAnimation {
                            duration: islandWindow.hoverHop
                                ? Data.Settings.animGlide
                                : Data.Settings.animMorph
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: [0.16, 1, 0.3, 1, 1, 1]
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation { duration: Data.Settings.animShort }
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: parent.radius * 0.65
                        anchors.rightMargin: parent.radius * 0.65
                        height: 1
                        color: Qt.alpha(Data.Settings.fgColor, 0.08)
                    }

                    Item {
                        id: rest

                        anchors.fill: parent
                        enabled: islandWindow.mode === "rest"
                        opacity: enabled ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: Data.Settings.animFast }
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 9

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "時"
                                color: Data.Settings.warmAccent
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: Data.Time.time
                                color: Data.Settings.fgColor
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                            }
                        }
                    }

                    Item {
                        id: hover

                        anchors.fill: parent
                        enabled: islandWindow.mode === "hover"
                        opacity: enabled ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: Data.Settings.animFast }
                        }

                        Row {
                            id: hoverRow

                            anchors.centerIn: parent
                            spacing: 20

                            Bar.Workspaces {
                                anchors.verticalCenter: parent.verticalCenter
                                screen: islandWindow.screen
                            }

                            PillDivider {}

                            Item {
                                anchors.verticalCenter: parent.verticalCenter
                                width: hoverClock.implicitWidth
                                height: hoverClock.implicitHeight

                                Column {
                                    id: hoverClock
                                    anchors.centerIn: parent
                                    spacing: 1

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Data.Time.time
                                        color: Data.Settings.fgColor
                                        font.pixelSize: 17
                                        font.weight: Font.DemiBold
                                    }
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Data.Time.barDate.toUpperCase()
                                        color: Data.Settings.fgDim
                                        font.pixelSize: 8
                                        font.weight: Font.Medium
                                        font.letterSpacing: 1.3
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -7
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Data.Runtime.togglePage("calendar")
                                }
                            }

                            PillDivider {}

                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 12

                                IslandComponents.PillIcon {
                                    icon: "weather-clear-symbolic"
                                    text: Services.Weather.temperature
                                    accent: Data.Settings.warningColor
                                    onTriggered: Data.Runtime.togglePage("calendar")
                                }

                                Bar.SysTray {
                                    id: tray
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: itemCount > 0
                                }

                                IslandComponents.PillIcon {
                                    visible: Data.Settings.notificationsEnabled
                                        && Services.Notifications.dnd
                                    icon: "notifications-disabled-symbolic"
                                    selected: true
                                    accent: Data.Settings.errorColor
                                    onTriggered: Services.Notifications.toggleDnd()
                                }

                                IslandComponents.PillIcon {
                                    icon: Services.Networking.icon
                                    selected: Services.Networking.connected
                                    accent: Services.Networking.connected
                                        ? Data.Settings.successColor
                                        : Data.Settings.warningColor
                                    onTriggered: Data.Runtime.togglePage("network")
                                }

                                IslandComponents.PillIcon {
                                    icon: Services.Bluetooth.icon
                                    selected: Services.Bluetooth.connected
                                    accent: Data.Settings.blueColor
                                    onTriggered: Data.Runtime.togglePage("network")
                                }

                                IslandComponents.PillIcon {
                                    visible: Services.UPower.hasBattery
                                    icon: ""
                                    text: Math.round(Services.UPower.percentage) + "%"
                                    selected: Services.UPower.charging
                                    accent: Services.UPower.charging
                                        ? Data.Settings.successColor
                                        : Data.Settings.warningColor
                                    onTriggered: Data.Runtime.togglePage("network")
                                }

                                IslandComponents.PillIcon {
                                    visible: Data.Settings.notificationsEnabled
                                    icon: Services.Notifications.icon
                                    unread: Services.Notifications.count > 0
                                    accent: Data.Settings.errorColor
                                    onTriggered: Data.Runtime.togglePage("notifications")
                                }

                                IslandComponents.PillIcon {
                                    icon: "audio-volume-high-symbolic"
                                    selected: Services.Pipewire.muted
                                    accent: Data.Settings.errorColor
                                    onTriggered: Data.Runtime.togglePage("media")
                                }

                                IslandComponents.PillIcon {
                                    icon: "utilities-system-monitor-symbolic"
                                    onTriggered: Data.Runtime.togglePage("system")
                                }

                                IslandComponents.PillIcon {
                                    icon: "media-record-symbolic"
                                    onTriggered: Quickshell.execDetached(["obs"])
                                }

                                IslandComponents.PillIcon {
                                    icon: "preferences-desktop-wallpaper-symbolic"
                                    onTriggered: Quickshell.execDetached([
                                        "xdg-open",
                                        Quickshell.env("HOME") + "/Pictures"
                                    ])
                                }

                                IslandComponents.PillIcon {
                                    icon: "edit-paste-symbolic"
                                    onTriggered: Quickshell.execDetached([
                                        "clipcat-menu",
                                        "--rofi-menu-length",
                                        "10"
                                    ])
                                }

                                IslandComponents.PillIcon {
                                    icon: "application-x-executable-symbolic"
                                    onTriggered: Quickshell.execDetached(["anyrun"])
                                }

                                IslandComponents.PillIcon {
                                    icon: "applications-graphics-symbolic"
                                    onTriggered: Data.Runtime.togglePage("system")
                                }

                                IslandComponents.PillIcon {
                                    icon: "system-shutdown-symbolic"
                                    accent: Data.Settings.errorColor
                                    onTriggered: Data.Runtime.togglePage("power")
                                }
                            }

                        }
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: -4
                        anchors.verticalCenter: parent.verticalCenter
                        width: 8
                        height: 8
                        radius: 4
                        visible: opacity > 0.01
                        opacity: islandWindow.mode === "hover" ? 1 : 0
                        color: Data.Settings.warmAccent

                        Behavior on opacity {
                            NumberAnimation { duration: Data.Settings.animFast }
                        }
                    }

                    Item {
                        id: surfacePanel

                        anchors.fill: parent
                        enabled: islandWindow.mode === "surface"
                        opacity: enabled ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: Data.Settings.animShort }
                        }

                        RowLayout {
                            id: surfaceHeader

                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 11
                            anchors.leftMargin: 16
                            anchors.rightMargin: 12
                            height: 24
                            spacing: 8

                            Text {
                                text: islandWindow.surfaceGlyph(Data.Runtime.activePage)
                                color: Data.Settings.warmAccent
                                font.pixelSize: Data.Settings.fontLg
                                font.weight: Font.Bold
                            }

                            Text {
                                text: islandWindow.surfaceTitle(Data.Runtime.activePage).toUpperCase()
                                color: Data.Settings.fgDim
                                font.pixelSize: Data.Settings.fontXs
                                font.weight: Font.DemiBold
                                font.letterSpacing: 1.6
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                visible: Data.Runtime.activePage === "system"
                                text: "UP " + Services.SystemInfo.uptime
                                color: Data.Settings.fgDim
                                font.pixelSize: Data.Settings.fontXs
                            }

                            Rectangle {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                radius: 12
                                color: closeMouse.containsMouse
                                    ? Data.Settings.hoverBg
                                    : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "×"
                                    color: Data.Settings.fgDim
                                    font.pixelSize: Data.Settings.fontLg
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
                            anchors.top: surfaceHeader.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 7
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            height: 1
                            color: Data.Settings.hairline
                        }

                        Loader {
                            anchors.fill: parent
                            anchors.topMargin: 49
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            anchors.bottomMargin: 14
                            active: islandWindow.surfaceOpen
                            sourceComponent: {
                                switch (Data.Runtime.activePage) {
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
            }

            Component { id: calendarPage; IslandComponents.CalendarPage {} }
            Component { id: mediaPage; IslandComponents.MediaPage {} }
            Component { id: connectivityPage; IslandComponents.ConnectivityPage {} }
            Component { id: notificationsPage; IslandComponents.NotificationsPage {} }
            Component { id: powerPage; IslandComponents.PowerPage {} }
            Component { id: systemPage; IslandComponents.SystemPage {} }

            component PillDivider: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1
                height: 22
                color: Data.Settings.hairline
            }
        }
    }
}
