pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string notificationBackend: Quickshell.env("QS_NOTIFICATION_BACKEND") ?? "quickshell"
    readonly property bool notificationsEnabled: notificationBackend === "quickshell"

    // Independent fallback palette for source previews. The Nix target maps
    // these literals to the current Guernica Base16 palette.
    readonly property color bgColor: "#141818"
    readonly property color bgColorTranslucent: Qt.alpha(bgColor, 0.62)
    readonly property color bgLight: "#1e2424"
    readonly property color bgLightTranslucent: Qt.alpha(bgLight, 0.68)
    readonly property color bgLighter: "#3c4848"
    readonly property color fgColor: "#f8f8f8"
    readonly property color fgDim: "#909090"
    readonly property color accentColor: "#40c4ff"
    readonly property color warningColor: "#ffb000"
    readonly property color successColor: "#a0ff20"
    readonly property color errorColor: "#ff0060"
    readonly property color purpleColor: "#c080ff"
    readonly property color blueColor: "#6080ff"
    readonly property color yellowColor: "#ffe080"

    readonly property color activeColor: fgColor
    readonly property color inactiveColor: fgDim
    readonly property color warmAccent: activeColor

    readonly property color borderSubtle: Qt.rgba(1, 1, 1, 0.06)
    readonly property color borderNormal: Qt.rgba(1, 1, 1, 0.10)
    readonly property color borderHover: Qt.rgba(1, 1, 1, 0.14)
    readonly property color hoverBg: Qt.rgba(1, 1, 1, 0.1)
    readonly property color hairline: Qt.alpha(fgColor, 0.12)
    readonly property color glassEdge: Qt.rgba(1, 1, 1, 0.18)
    readonly property color glassSpecular: Qt.rgba(1, 1, 1, 0.22)
    readonly property color surfaceTop: Qt.alpha(bgLight, 0.26)
    readonly property color surfaceBottom: Qt.alpha(bgColor, 0.40)
    readonly property color surfaceTopOpen: Qt.alpha(bgLight, 0.40)
    readonly property color surfaceBottomOpen: Qt.alpha(bgColor, 0.52)

    readonly property int rounding: 10
    readonly property int popupRadius: 15
    readonly property real popupScaleHidden: 0.96

    readonly property int islandMargin: 8
    readonly property int islandDockHeight: 50
    readonly property int islandDockRadius: 14
    readonly property int islandDockPadding: 17

    readonly property int launcherWidth: 430
    readonly property int launcherHeight: 374
    readonly property int clipboardWidth: 430
    readonly property int clipboardHeight: 350
    readonly property int bluetoothWidth: 420
    readonly property int bluetoothHeight: 340
    readonly property int mixerWidth: 420
    readonly property int mixerHeight: 272
    readonly property int calendarWidth: 500
    readonly property int calendarHeight: 280
    readonly property int mediaWidth: 430
    readonly property int mediaHeight: 176
    readonly property int networkWidth: 430
    readonly property int networkHeight: 330
    readonly property int notificationsWidth: 430
    readonly property int notificationsHeight: 400
    readonly property int systemWidth: 430
    readonly property int systemHeight: 248
    readonly property int powerWidth: 370
    readonly property int powerHeight: 176

    readonly property int animFast: 100
    readonly property int animShort: 150
    readonly property int animMedium: 250
    readonly property int animGlide: 190
    readonly property int animMorph: 230

    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 20
    readonly property int spacingXxl: 24

    readonly property int fontXs: 11
    readonly property int fontSm: 13
    readonly property int fontBase: 15
    readonly property int fontLg: 17
    readonly property int fontXl: 20
    readonly property int fontXxl: 34

    readonly property int iconSm: 16
    readonly property int iconMd: 20
    readonly property int iconLg: 23

    readonly property color notificationSurface: bgLightTranslucent
    readonly property color notificationBorder: borderNormal
    readonly property int notificationWidth: 352
    readonly property int notificationRadius: rounding
    readonly property int notificationPadding: spacingLg
    readonly property int notificationGap: spacingSm
    readonly property int notificationIconSize: 36
}
