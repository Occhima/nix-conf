import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import "root:/data" as Data
import "root:/services" as Services

Scope {
    id: controlCenter

    // Animation durations
    readonly property int animShort: 150
    readonly property int animMedium: 250

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-controlcenter"
            exclusiveZone: 0
            visible: Data.Runtime.quickSettingsVisible

            anchors {
                top: true
                right: true
            }

            implicitHeight: panelContent.height + Data.Settings.barHeight + Data.Settings.barMargin * 2 + 16
            implicitWidth: 380

            color: "transparent"

            // Click outside to close
            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            // Main Panel
            Rectangle {
                id: panelContent
                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight + Data.Settings.barMargin * 2 + 12
                    right: parent.right
                    rightMargin: Data.Settings.barSideMargin
                }
                width: 340
                height: contentLayout.implicitHeight + 40
                color: Data.Settings.bgColorTranslucent
                radius: 24
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.08)

                // Block clicks from closing
                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                // Appear animation
                scale: Data.Runtime.quickSettingsVisible ? 1.0 : 0.94
                opacity: Data.Runtime.quickSettingsVisible ? 1.0 : 0

                Behavior on scale {
                    NumberAnimation { duration: controlCenter.animMedium; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: controlCenter.animShort }
                }

                transformOrigin: Item.TopRight

                ColumnLayout {
                    id: contentLayout
                    anchors {
                        fill: parent
                        margins: 20
                    }
                    spacing: 16

                    // Header: Time & Date + Actions
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        ColumnLayout {
                            spacing: 2

                            Text {
                                id: timeText
                                text: Qt.formatTime(new Date(), "hh:mm")
                                font.pixelSize: 32
                                font.weight: Font.Bold
                                color: Data.Settings.fgColor
                            }

                            Text {
                                text: Qt.formatDate(new Date(), "dddd, MMMM d")
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: Data.Settings.fgDim
                            }

                            Timer {
                                interval: 1000
                                running: Data.Runtime.quickSettingsVisible
                                repeat: true
                                onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm")
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // Header action buttons
                        RowLayout {
                            spacing: 6

                            HeaderButton {
                                icon: "network-wireless-symbolic"
                                tooltip: "Network Settings"
                                onClicked: settingsProcess.running = true
                            }
                            HeaderButton {
                                icon: "system-lock-screen-symbolic"
                                tooltip: "Lock Screen"
                                onClicked: lockProcess.running = true
                            }
                            HeaderButton {
                                icon: "system-shutdown-symbolic"
                                tooltip: "Power Menu"
                                onClicked: powerProcess.running = true
                            }
                        }
                    }

                    // Divider
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.08)
                    }

                    // Quick Toggles Grid
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: 10
                        rowSpacing: 10

                        QuickToggle {
                            Layout.fillWidth: true
                            icon: "network-wireless-symbolic"
                            label: "Wi-Fi"
                            subLabel: Services.Networking.wifiConnected ? Services.Networking.wifiSsid : "Disconnected"
                            active: Services.Networking.wifiEnabled
                            activeColor: Data.Settings.accentColor
                            onClicked: Services.Networking.toggleWifi()
                        }

                        QuickToggle {
                            Layout.fillWidth: true
                            icon: "bluetooth-symbolic"
                            label: "Bluetooth"
                            subLabel: Services.Bluetooth.connected ? (Services.Bluetooth.connectedDevice?.name ?? "Connected") : (Services.Bluetooth.powered ? "On" : "Off")
                            active: Services.Bluetooth.powered
                            activeColor: Data.Settings.accentColor
                            onClicked: Services.Bluetooth.toggle()
                        }

                        QuickToggle {
                            Layout.fillWidth: true
                            icon: "notifications-disabled-symbolic"
                            label: "Do Not Disturb"
                            subLabel: Services.Notifications.dnd ? "On" : "Off"
                            active: Services.Notifications.dnd
                            activeColor: Data.Settings.warningColor
                            onClicked: Services.Notifications.toggleDnd()
                        }

                        QuickToggle {
                            Layout.fillWidth: true
                            icon: "audio-volume-muted-symbolic"
                            label: Services.Pipewire.muted ? "Muted" : "Sound"
                            subLabel: Services.Pipewire.muted ? "Tap to unmute" : Math.round(Services.Pipewire.volume * 100) + "%"
                            active: Services.Pipewire.muted
                            activeColor: Data.Settings.errorColor
                            onClicked: Services.Pipewire.toggleMute()
                        }
                    }

                    // Divider
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.08)
                    }

                    // Volume Slider
                    SliderControl {
                        Layout.fillWidth: true
                        icon: Services.Pipewire.volumeIcon
                        label: "Volume"
                        value: Services.Pipewire.volume
                        accentColor: Data.Settings.accentColor
                        onSliderMoved: newVal => Services.Pipewire.setVolume(newVal)
                    }

                    // Divider
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.08)
                    }

                    // System Stats
                    SystemStats {
                        Layout.fillWidth: true
                    }

                    // Battery info (if present)
                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        radius: 12
                        color: Data.Settings.bgLight
                        visible: Services.UPower.hasBattery

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 12

                            Image {
                                source: Quickshell.iconPath(Services.UPower.icon)
                                width: 20
                                height: 20
                                sourceSize: Qt.size(20, 20)
                            }

                            Text {
                                text: Services.UPower.tooltip
                                color: Data.Settings.fgColor
                                font.pixelSize: 13
                                font.weight: Font.Medium
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: Math.round(Services.UPower.percentage) + "%"
                                color: Data.Settings.fgDim
                                font.pixelSize: 13
                                font.weight: Font.Bold
                            }
                        }
                    }
                }
            }
        }
    }

    // Process launchers
    Process {
        id: settingsProcess
        command: ["qs-network-settings"]
        onStarted: Data.Runtime.closeAll()
    }

    Process {
        id: lockProcess
        command: ["qs-lock"]
        onStarted: Data.Runtime.closeAll()
    }

    Process {
        id: powerProcess
        command: ["qs-logout"]
        onStarted: Data.Runtime.closeAll()
    }

    // Header Button Component
    component HeaderButton: Rectangle {
        id: headerBtn
        property string icon
        property string tooltip: ""
        signal clicked()

        width: 36
        height: 36
        radius: 18
        color: headerMouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight

        Behavior on color {
            ColorAnimation { duration: controlCenter.animShort }
        }

        scale: headerMouse.pressed ? 0.92 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 100 }
        }

        Image {
            anchors.centerIn: parent
            source: Quickshell.iconPath(headerBtn.icon)
            width: 16
            height: 16
            sourceSize: Qt.size(16, 16)
        }

        MouseArea {
            id: headerMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: headerBtn.clicked()
        }
    }

    // Quick Toggle Component
    component QuickToggle: Rectangle {
        id: toggle
        property string icon
        property string label
        property string subLabel
        property bool active: false
        property color activeColor: Data.Settings.accentColor
        signal clicked()

        height: 64
        radius: 20
        color: active ? activeColor : Data.Settings.bgLight

        Behavior on color {
            ColorAnimation { duration: controlCenter.animMedium; easing.type: Easing.OutCubic }
        }

        scale: toggleMouse.pressed ? 0.96 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 100 }
        }

        // Hover overlay
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: toggle.active ? Qt.rgba(0, 0, 0, 0.1) : Qt.rgba(255, 255, 255, 0.05)
            opacity: toggleMouse.containsMouse && !toggleMouse.pressed ? 1 : 0
            Behavior on opacity {
                NumberAnimation { duration: controlCenter.animShort }
            }
        }

        MouseArea {
            id: toggleMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: toggle.clicked()
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            // Icon circle
            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                radius: 18
                color: toggle.active ? Qt.rgba(255, 255, 255, 0.25) : Data.Settings.bgLighter

                Behavior on color {
                    ColorAnimation { duration: controlCenter.animShort }
                }

                Image {
                    anchors.centerIn: parent
                    source: Quickshell.iconPath(toggle.icon)
                    width: 18
                    height: 18
                    sourceSize: Qt.size(18, 18)
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: toggle.label
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: toggle.active ? Data.Settings.bgColor : Data.Settings.fgColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true

                    Behavior on color {
                        ColorAnimation { duration: controlCenter.animShort }
                    }
                }

                Text {
                    text: toggle.subLabel
                    font.pixelSize: 11
                    color: toggle.active ? Qt.rgba(0, 0, 0, 0.6) : Data.Settings.fgDim
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    visible: text !== ""

                    Behavior on color {
                        ColorAnimation { duration: controlCenter.animShort }
                    }
                }
            }
        }
    }

    // Slider Control Component
    component SliderControl: ColumnLayout {
        id: slider
        property string icon
        property string label
        property real value: 0
        property color accentColor: Data.Settings.accentColor
        signal sliderMoved(real newVal)

        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Image {
                source: Quickshell.iconPath(slider.icon)
                width: 18
                height: 18
                sourceSize: Qt.size(18, 18)
            }

            Text {
                text: slider.label
                color: Data.Settings.fgColor
                font.pixelSize: 13
                font.weight: Font.Medium
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Math.round(slider.value * 100) + "%"
                color: Data.Settings.fgDim
                font.pixelSize: 12
                font.weight: Font.Bold
            }
        }

        // Slider track
        Rectangle {
            Layout.fillWidth: true
            height: 8
            radius: 4
            color: Data.Settings.bgLighter

            Rectangle {
                width: parent.width * Math.min(1, slider.value)
                height: parent.height
                radius: parent.radius
                color: slider.accentColor

                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }

            // Slider knob
            Rectangle {
                x: parent.width * Math.min(1, slider.value) - width / 2
                anchors.verticalCenter: parent.verticalCenter
                width: 16
                height: 16
                radius: 8
                color: Data.Settings.fgColor
                visible: sliderMouse.containsMouse || sliderMouse.pressed

                Behavior on x {
                    NumberAnimation { duration: 50 }
                }
            }

            MouseArea {
                id: sliderMouse
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                onClicked: mouse => {
                    const val = Math.max(0, Math.min(1, mouse.x / parent.width))
                    slider.sliderMoved(val)
                }
                onPositionChanged: mouse => {
                    if (pressed) {
                        const val = Math.max(0, Math.min(1, mouse.x / parent.width))
                        slider.sliderMoved(val)
                    }
                }
            }
        }
    }

    // System Stats Component
    component SystemStats: Rectangle {
        height: 64
        radius: 16
        color: Data.Settings.bgLight

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 0

            Item { Layout.fillWidth: true }

            StatItem {
                icon: "cpu-symbolic"
                label: "CPU"
                value: Services.SystemUsage.cpuUsage
                accentColor: Data.Settings.errorColor
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 1
                height: 36
                color: Qt.rgba(255, 255, 255, 0.08)
            }

            Item { Layout.fillWidth: true }

            StatItem {
                icon: "memory-symbolic"
                label: "RAM"
                value: Services.SystemUsage.memUsage
                accentColor: Data.Settings.warningColor
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 1
                height: 36
                color: Qt.rgba(255, 255, 255, 0.08)
            }

            Item { Layout.fillWidth: true }

            StatItem {
                icon: "drive-harddisk-symbolic"
                label: "Disk"
                value: Services.SystemUsage.diskUsage
                accentColor: Data.Settings.accentColor
            }

            Item { Layout.fillWidth: true }
        }
    }

    // Stat Item Component
    component StatItem: ColumnLayout {
        property string icon
        property string label
        property real value
        property color accentColor

        spacing: 4

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Image {
                source: Quickshell.iconPath(icon)
                width: 14
                height: 14
                sourceSize: Qt.size(14, 14)
            }

            Text {
                text: Math.round(value * 100) + "%"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: Data.Settings.fgColor
            }
        }

        // Progress bar
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 44
            Layout.preferredHeight: 3
            radius: 1.5
            color: Data.Settings.bgLighter

            Rectangle {
                width: parent.width * Math.min(value, 1)
                height: parent.height
                radius: 1.5
                color: accentColor

                Behavior on width {
                    NumberAnimation { duration: controlCenter.animMedium }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: label
            font.pixelSize: 10
            font.weight: Font.Medium
            color: Data.Settings.fgDim
        }
    }
}
