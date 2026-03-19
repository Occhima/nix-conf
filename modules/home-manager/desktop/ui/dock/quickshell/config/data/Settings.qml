pragma Singleton

import QtQuick

QtObject {
    readonly property color bgColor: "#141818"
    readonly property color bgColorTranslucent: Qt.rgba(0.078, 0.094, 0.094, 0.85)
    readonly property color bgLight: "#1e2424"
    readonly property color bgLightTranslucent: Qt.rgba(0.118, 0.141, 0.141, 0.9)
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
    readonly property int barSideMargin: 16
}
