pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string notificationBackend: Quickshell.env("QS_NOTIFICATION_BACKEND") ?? "quickshell"
    readonly property bool notificationsEnabled: notificationBackend === "quickshell"

    readonly property color bgColor: "#141818"
    readonly property color bgColorTranslucent: Qt.alpha(bgColor, 0.85)
    readonly property color bgLight: "#1e2424"
    readonly property color bgLightTranslucent: Qt.alpha(bgLight, 0.9)
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

    readonly property color borderSubtle: Qt.rgba(1, 1, 1, 0.06)
    readonly property color borderNormal: Qt.rgba(1, 1, 1, 0.08)
    readonly property color borderHover: Qt.rgba(1, 1, 1, 0.12)
    readonly property color hoverBg: Qt.rgba(1, 1, 1, 0.1)

    readonly property int rounding: 14
    readonly property int barHeight: 40
    readonly property int barMargin: 8
    readonly property int barSideMargin: 8

    readonly property int animFast: 100
    readonly property int animShort: 150
    readonly property int animMedium: 250

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

    readonly property real popupScaleHidden: 0.96
    readonly property int popupRadius: 24
    readonly property int iconSm: 14
    readonly property int iconMd: 16
    readonly property int iconLg: 18

    // Shared notification contract. Theme targets choose the surface; the
    // components consume these metrics instead of carrying private constants.
    readonly property color notificationSurface: bgColorTranslucent
    readonly property color notificationBorder: borderNormal
    readonly property int notificationWidth: 352
    readonly property int notificationRadius: rounding
    readonly property int notificationPadding: spacingLg
    readonly property int notificationGap: spacingSm
    readonly property int notificationIconSize: 36
}
