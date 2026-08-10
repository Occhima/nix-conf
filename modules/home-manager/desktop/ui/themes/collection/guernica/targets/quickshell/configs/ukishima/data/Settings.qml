pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string notificationBackend: Quickshell.env("QS_NOTIFICATION_BACKEND") ?? "quickshell"
    readonly property bool notificationsEnabled: notificationBackend === "quickshell"

    // Independent fallback palette for source previews. The Nix target maps
    // these literals to the current Guernica Base16 palette.
    readonly property color bgColor: "#141818"
    readonly property color bgColorTranslucent: Qt.alpha(bgColor, 0.92)
    readonly property color bgLight: "#1e2424"
    readonly property color bgLightTranslucent: Qt.alpha(bgLight, 0.94)
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
    readonly property color warmAccent: warningColor

    readonly property color borderSubtle: Qt.rgba(1, 1, 1, 0.06)
    readonly property color borderNormal: Qt.rgba(1, 1, 1, 0.10)
    readonly property color borderHover: Qt.rgba(1, 1, 1, 0.14)
    readonly property color hoverBg: Qt.rgba(1, 1, 1, 0.1)
    readonly property color hairline: Qt.alpha(fgColor, 0.12)
    readonly property color surfaceTop: Qt.alpha(bgLight, 0.97)
    readonly property color surfaceBottom: Qt.alpha(bgColor, 0.97)

    readonly property int rounding: 14
    readonly property int popupRadius: 22
    readonly property real popupScaleHidden: 0.96

    readonly property int islandMargin: 8
    readonly property int islandRestWidth: 160
    readonly property int islandRestHeight: 38
    readonly property int islandHoverHeight: 58
    readonly property int islandHoverPadding: 20

    readonly property int calendarWidth: 332
    readonly property int calendarHeight: 348
    readonly property int mediaWidth: 390
    readonly property int mediaHeight: 150
    readonly property int networkWidth: 390
    readonly property int networkHeight: 318
    readonly property int notificationsWidth: 390
    readonly property int notificationsHeight: 366
    readonly property int systemWidth: 392
    readonly property int systemHeight: 246
    readonly property int powerWidth: 330
    readonly property int powerHeight: 150

    readonly property int animFast: 100
    readonly property int animShort: 150
    readonly property int animMedium: 250
    readonly property int animGlide: 260
    readonly property int animHoverGrace: 300
    readonly property int animMorph: 420

    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 20
    readonly property int spacingXxl: 24

    readonly property int fontXs: 10
    readonly property int fontSm: 11
    readonly property int fontBase: 13
    readonly property int fontLg: 14
    readonly property int fontXl: 18
    readonly property int fontXxl: 32

    readonly property int iconSm: 14
    readonly property int iconMd: 16
    readonly property int iconLg: 18

    readonly property color notificationSurface: bgLightTranslucent
    readonly property color notificationBorder: borderNormal
    readonly property int notificationWidth: 352
    readonly property int notificationRadius: rounding
    readonly property int notificationPadding: spacingLg
    readonly property int notificationGap: spacingSm
    readonly property int notificationIconSize: 36
}
