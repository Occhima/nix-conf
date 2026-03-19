import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

import "root:/data" as Data
import "root:/services" as Services

Scope {
    id: dashboard

    readonly property int anim_short: 160
    readonly property int anim_medium: 260

    property date now: new Date()

    readonly property var active_player: {
        const players = Mpris.players.values;
        for (let i = 0; i < players.length; i++) {
            if (players[i] && players[i].isPlaying)
                return players[i];
        }
        return players.length > 0 ? players[0] : null;
    }

    readonly property real player_progress: {
        const p = active_player;
        if (!p || !p.length || p.length <= 0)
            return 0;
        return clamp01(p.position / p.length);
    }

    function clamp01(x) {
        return Math.max(0, Math.min(1, x));
    }

    function safe_string(value, fallback) {
        if (value === undefined || value === null)
            return fallback;
        const text = String(value).trim();
        return text.length ? text : fallback;
    }

    function safe_url(value) {
        if (value === undefined || value === null)
            return "";
        const text = String(value).trim();
        return text.length ? text : "";
    }

    function media_time_str(value) {
        if (value === undefined || value === null || value < 0)
            return "--:--";

        const total = Math.floor(value);
        const mins = Math.floor(total / 60);
        const secs = String(total % 60).padStart(2, "0");
        return `${mins}:${secs}`;
    }

    function weather_icon(desc) {
        const text = safe_string(desc, "").toLowerCase();

        if (text.includes("thunder"))
            return "⛈";
        if (text.includes("snow"))
            return "❄";
        if (text.includes("rain") || text.includes("drizzle"))
            return "☔";
        if (text.includes("cloud") || text.includes("overcast") || text.includes("mist"))
            return "☁";
        if (text.includes("clear") || text.includes("sun"))
            return "☼";

        return "☼";
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            dashboard.now = new Date();

            if (dashboard.active_player && dashboard.active_player.isPlaying)
                dashboard.active_player.positionChanged();
        }
    }

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-dashboard"
            visible: Data.Runtime.dashboardVisible
            exclusiveZone: 0

            anchors {
                top: true
                left: true
                right: true
            }

            implicitWidth: screen.width
            implicitHeight: panel.height + Data.Settings.barHeight
                            + Data.Settings.barMargin * 2 + 20
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: panel

                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight
                               + Data.Settings.barMargin * 2 + 14
                    horizontalCenter: parent.horizontalCenter
                }

                width: Math.min(820, screen.width - 40)
                height: content.implicitHeight + 28
                radius: 24
                color: Data.Settings.bgColorTranslucent
                border.width: 1
                border.color: Qt.alpha(Data.Settings.fgColor, 0.10)

                scale: Data.Runtime.dashboardVisible ? 1.0 : 0.965
                opacity: Data.Runtime.dashboardVisible ? 1.0 : 0.0
                transformOrigin: Item.Top

                Behavior on scale {
                    NumberAnimation {
                        duration: dashboard.anim_medium
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: dashboard.anim_short
                    }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 1
                    height: parent.height / 3
                    radius: parent.radius - 1
                    color: "transparent"

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: Qt.alpha("white", 0.045)
                        }
                        GradientStop {
                            position: 1.0
                            color: "transparent"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: function(mouse) {
                        mouse.accepted = true;
                    }
                }

                ColumnLayout {
                    id: content

                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        spacing: 8

                        Text {
                            text: "Dashboard"
                            color: Data.Settings.fgColor
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        CloseButton {}
                    }

                    RowLayout {
                        id: body

                        Layout.fillWidth: true
                        Layout.minimumHeight: 320
                        spacing: 12

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 12

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 110
                                spacing: 12

                                WeatherCard {
                                    Layout.preferredWidth: 180
                                    Layout.fillHeight: true
                                }

                                UserCard {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 280
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumHeight: 200
                                spacing: 12

                                DateTimeCard {
                                    Layout.preferredWidth: 104
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 180
                                }

                                CalendarCard {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 180
                                }

                                ResourceBarsCard {
                                    Layout.preferredWidth: 76
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 150
                                }
                            }
                        }

                        MediaCard {
                            Layout.preferredWidth: 208
                            Layout.fillHeight: true
                            Layout.minimumHeight: 300
                        }
                    }
                }
            }
        }
    }

    component CardFrame: Rectangle {
        radius: 18
        clip: true
        color: Data.Settings.bgLightTranslucent
        border.width: 1
        border.color: Qt.alpha(Data.Settings.fgColor, 0.07)

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 1
            height: parent.height / 2
            radius: parent.radius - 1
            color: "transparent"

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.alpha("white", 0.03)
                }
                GradientStop {
                    position: 1.0
                    color: "transparent"
                }
            }
        }
    }

    component CloseButton: Rectangle {
        id: close_button

        implicitWidth: 28
        implicitHeight: 28
        radius: 14

        color: close_mouse.containsMouse
            ? Qt.alpha(Data.Settings.errorColor, 0.18)
            : Qt.alpha(Data.Settings.fgColor, 0.05)

        border.width: 1
        border.color: close_mouse.containsMouse
            ? Qt.alpha(Data.Settings.errorColor, 0.28)
            : Qt.alpha(Data.Settings.fgColor, 0.08)

        Behavior on color {
            ColorAnimation { duration: dashboard.anim_short }
        }

        Behavior on border.color {
            ColorAnimation { duration: dashboard.anim_short }
        }

        Text {
            anchors.centerIn: parent
            text: "×"
            color: Data.Settings.fgColor
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        MouseArea {
            id: close_mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: function(mouse) {
                mouse.accepted = true;
                Data.Runtime.closeAll();
            }
        }
    }

    component WeatherCard: CardFrame {
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: dashboard.weather_icon(Services.Weather ? Services.Weather.description : "")
                color: Data.Settings.warningColor
                font.pixelSize: 34
                font.weight: Font.Light
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: dashboard.safe_string(
                        Services.Weather ? Services.Weather.temperature : undefined,
                        "--°"
                    )
                    color: Data.Settings.fgColor
                    font.pixelSize: 30
                    font.weight: Font.Medium
                }

                Text {
                    text: dashboard.safe_string(
                        Services.Weather ? Services.Weather.description : undefined,
                        "Weather"
                    )
                    color: Data.Settings.fgDim
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }
        }
    }

    component UserCard: CardFrame {
        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 14

            Rectangle {
                id: avatar_wrap

                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                radius: 18
                clip: true
                color: Qt.alpha(Data.Settings.fgColor, 0.05)
                border.width: 1
                border.color: Qt.alpha(Data.Settings.fgColor, 0.06)

                Image {
                    id: face

                    anchors.fill: parent
                    source: dashboard.safe_url(
                        Services.SystemInfo ? Services.SystemInfo.facePath : undefined
                    )
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: false
                }

                Text {
                    anchors.centerIn: parent
                    visible: face.status !== Image.Ready
                    text: dashboard.safe_string(
                        Services.SystemInfo ? Services.SystemInfo.user : undefined,
                        "U"
                    ).charAt(0).toUpperCase()
                    color: Data.Settings.fgColor
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 6

                InfoRow {
                    dot_color: Data.Settings.warningColor
                    text: dashboard.safe_string(
                        Services.SystemInfo ? Services.SystemInfo.osPrettyName : undefined,
                        "Linux"
                    )
                }

                InfoRow {
                    dot_color: Data.Settings.accentColor
                    text: dashboard.safe_string(
                        Services.SystemInfo ? Services.SystemInfo.wm : undefined,
                        "Wayland"
                    )
                }

                InfoRow {
                    dot_color: Data.Settings.successColor
                    text: "up " + dashboard.safe_string(
                        Services.SystemInfo ? Services.SystemInfo.uptime : undefined,
                        "..."
                    )
                }
            }
        }
    }

    component InfoRow: RowLayout {
        property color dot_color: "white"
        property string text: ""

        spacing: 8

        Rectangle {
            Layout.preferredWidth: 6
            Layout.preferredHeight: 6
            radius: 3
            color: parent.dot_color
        }

        Text {
            Layout.fillWidth: true
            text: parent.text
            color: Data.Settings.fgColor
            font.pixelSize: 13
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }

    component DateTimeCard: CardFrame {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 4

            Item { Layout.fillHeight: true }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatTime(dashboard.now, "hh\nmm")
                color: Data.Settings.fgColor
                font.pixelSize: 28
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDate(dashboard.now, "ddd, d")
                color: Data.Settings.fgDim
                font.pixelSize: 12
            }

            Item { Layout.fillHeight: true }
        }
    }

    component CalendarCard: CardFrame {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Text {
                text: Qt.formatDate(dashboard.now, "MMMM yyyy")
                color: Data.Settings.fgColor
                font.pixelSize: 14
                font.weight: Font.DemiBold
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                Repeater {
                    model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

                    Text {
                        Layout.fillWidth: true
                        text: modelData
                        color: Data.Settings.fgDim
                        font.pixelSize: 11
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            GridLayout {
                id: calendar_grid

                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 7
                columnSpacing: 0
                rowSpacing: 4

                property var cells: {
                    const year = dashboard.now.getFullYear();
                    const month = dashboard.now.getMonth();
                    const first = new Date(year, month, 1);
                    const last = new Date(year, month + 1, 0);
                    const monday_start = (first.getDay() + 6) % 7;
                    const prev_last = new Date(year, month, 0).getDate();

                    const out = [];

                    for (let i = monday_start - 1; i >= 0; i--)
                        out.push({ day: prev_last - i, current: false });

                    for (let i = 1; i <= last.getDate(); i++)
                        out.push({ day: i, current: true });

                    while (out.length < 42)
                        out.push({ day: out.length - last.getDate() - monday_start + 1, current: false });

                    return out;
                }

                Repeater {
                    model: calendar_grid.cells

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        radius: 12
                        color: {
                            if (!modelData.current)
                                return "transparent";

                            const current_now = dashboard.now;
                            const is_today =
                                modelData.day === current_now.getDate()
                                && current_now.getMonth() === (new Date()).getMonth()
                                && current_now.getFullYear() === (new Date()).getFullYear();

                            return is_today
                                ? Qt.alpha(Data.Settings.warningColor, 0.85)
                                : "transparent";
                        }

                        Text {
                            anchors.centerIn: parent
                            text: String(modelData.day)
                            color: {
                                if (!modelData.current)
                                    return Qt.alpha(Data.Settings.fgDim, 0.7);

                                const current_now = dashboard.now;
                                const is_today =
                                    modelData.day === current_now.getDate()
                                    && current_now.getMonth() === (new Date()).getMonth()
                                    && current_now.getFullYear() === (new Date()).getFullYear();

                                return is_today ? Data.Settings.bgColor : Data.Settings.fgColor;
                            }
                            font.pixelSize: 11
                            font.weight: {
                                const current_now = dashboard.now;
                                const is_today =
                                    modelData.current
                                    && modelData.day === current_now.getDate()
                                    && current_now.getMonth() === (new Date()).getMonth()
                                    && current_now.getFullYear() === (new Date()).getFullYear();

                                return is_today ? Font.DemiBold : Font.Normal;
                            }
                        }
                    }
                }
            }
        }
    }

    component ResourceBarsCard: CardFrame {
        Row {
            anchors.centerIn: parent
            spacing: 10

            ResourceBar {
                value: Services.SystemUsage ? Services.SystemUsage.cpuUsage : 0
                fill_color: Data.Settings.warningColor
                label: "C"
            }

            ResourceBar {
                value: Services.SystemUsage ? Services.SystemUsage.memUsage : 0
                fill_color: Data.Settings.accentColor
                label: "M"
            }

            ResourceBar {
                value: Services.SystemUsage ? Services.SystemUsage.diskUsage : 0
                fill_color: Data.Settings.purpleColor
                label: "D"
            }
        }
    }

    component ResourceBar: Item {
        property real value: 0
        property color fill_color: "white"
        property string label: ""

        width: 12
        height: 132

        Rectangle {
            id: track

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: 8
            height: parent.height - 18
            radius: 4
            color: Qt.alpha(Data.Settings.fgColor, 0.08)

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: Math.max(4, track.height * dashboard.clamp01(parent.parent.value))
                radius: 4
                color: parent.parent.fill_color

                Behavior on height {
                    NumberAnimation {
                        duration: dashboard.anim_medium
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.label
            color: Data.Settings.fgDim
            font.pixelSize: 9
            font.weight: Font.DemiBold
        }
    }

    component MediaCard: CardFrame {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8

            Rectangle {
                id: cover_wrap

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 104
                Layout.preferredHeight: 104
                radius: 28
                clip: true
                color: Qt.alpha(Data.Settings.fgColor, 0.05)

                Image {
                    id: cover_img

                    anchors.fill: parent
                    source: dashboard.safe_url(
                        dashboard.active_player ? dashboard.active_player.trackArtUrl : undefined
                    )
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }

                Text {
                    anchors.centerIn: parent
                    visible: cover_img.status !== Image.Ready
                    text: "♪"
                    color: Data.Settings.fgDim
                    font.pixelSize: 28
                }
            }

            Text {
                Layout.fillWidth: true
                text: dashboard.safe_string(
                    dashboard.active_player ? dashboard.active_player.trackTitle : undefined,
                    "No media"
                )
                color: Data.Settings.fgColor
                font.pixelSize: 13
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                text: dashboard.safe_string(
                    dashboard.active_player ? dashboard.active_player.trackArtist : undefined,
                    "Start a player with MPRIS"
                )
                color: Data.Settings.fgDim
                font.pixelSize: 11
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                Layout.fillHeight: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 6
                radius: 3
                color: Qt.alpha(Data.Settings.fgColor, 0.08)

                Rectangle {
                    width: parent.width * dashboard.player_progress
                    height: parent.height
                    radius: 3
                    color: Data.Settings.accentColor

                    Behavior on width {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: dashboard.active_player
                    ? `${dashboard.media_time_str(dashboard.active_player.position)} / ${dashboard.media_time_str(dashboard.active_player.length)}`
                    : "--:-- / --:--"
                color: Data.Settings.fgDim
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                MediaButton {
                    symbol: "⏮"
                    enabled: dashboard.active_player && dashboard.active_player.canGoPrevious
                    onPressed: function() {
                        dashboard.active_player.previous();
                    }
                }

                MediaButton {
                    symbol: dashboard.active_player && dashboard.active_player.isPlaying ? "⏸" : "⏵"
                    primary: true
                    enabled: dashboard.active_player && dashboard.active_player.canTogglePlaying
                    onPressed: function() {
                        dashboard.active_player.togglePlaying();
                    }
                }

                MediaButton {
                    symbol: "⏭"
                    enabled: dashboard.active_player && dashboard.active_player.canGoNext
                    onPressed: function() {
                        dashboard.active_player.next();
                    }
                }
            }
        }
    }

    component MediaButton: Rectangle {
        id: button

        property string symbol: ""
        property bool primary: false
        signal pressed()

        implicitWidth: primary ? 38 : 34
        implicitHeight: primary ? 38 : 34
        radius: implicitHeight / 2

        color: !enabled
            ? Qt.alpha(Data.Settings.fgColor, 0.03)
            : primary
                ? Qt.alpha(Data.Settings.accentColor, 0.16)
                : (mouse.containsMouse
                    ? Qt.alpha(Data.Settings.fgColor, 0.07)
                    : Qt.alpha(Data.Settings.fgColor, 0.04))

        border.width: 1
        border.color: primary
            ? Qt.alpha(Data.Settings.accentColor, 0.24)
            : Qt.alpha(Data.Settings.fgColor, 0.06)

        opacity: enabled ? 1.0 : 0.45

        Behavior on color {
            ColorAnimation { duration: dashboard.anim_short }
        }

        Text {
            anchors.centerIn: parent
            text: button.symbol
            color: Data.Settings.fgColor
            font.pixelSize: button.primary ? 16 : 14
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: parent.enabled
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: function(mouse) {
                mouse.accepted = true;
                button.pressed();
            }
        }
    }
}
