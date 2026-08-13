import QtQuick

import "root:/data" as Data

Item {
    id: root

    property string name: ""
    property color color: Data.Settings.fgDim
    property real strokeWidth: 1.8
    property bool filled: false

    readonly property var glyphs: ({
        "search": "search",
        "sun": "clear_day",
        "cloud": "cloud",
        "rain": "rainy",
        "snow": "weather_snowy",
        "wifi": "wifi",
        "ethernet": "lan",
        "bluetooth": "bluetooth",
        "battery": "battery_horiz_075",
        "bell": "notifications",
        "mixer": "tune",
        "monitor": "monitor",
        "music": "music_note",
        "clipboard": "content_paste",
        "image": "image",
        "power": "power_settings_new",
        "close": "close"
    })

    readonly property real iconSize: Math.max(1, Math.min(root.width, root.height))

    Text {
        anchors.centerIn: parent
        text: root.glyphs[root.name] ?? root.name
        color: root.color
        font.family: "Material Symbols Rounded"
        font.pixelSize: root.iconSize
        font.variableAxes: ({
            "FILL": root.filled ? 1 : 0,
            "wght": Math.max(100, Math.min(700, Math.round(root.strokeWidth * 200))),
            "GRAD": 0,
            "opsz": root.iconSize
        })
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
    }
}
