pragma Singleton

import QtQuick

QtObject {
    // Guernica / Polykai color scheme
    readonly property string bgColor: "#141818"
    readonly property string bgLight: "#1e2424"
    readonly property string bgLighter: "#3c4848"
    readonly property string fgColor: "#f8f8f8"
    readonly property string fgDim: "#909090"
    readonly property string accentColor: "#40c4ff"
    readonly property string warningColor: "#ffb000"
    readonly property string successColor: "#a0ff20"
    readonly property string errorColor: "#ff0060"
    readonly property string purpleColor: "#c080ff"
    readonly property string blueColor: "#6080ff"
    readonly property string yellowColor: "#ffe080"

    readonly property int rounding: 14
    readonly property int barWidth: 48
    readonly property int barMargin: 10
}
