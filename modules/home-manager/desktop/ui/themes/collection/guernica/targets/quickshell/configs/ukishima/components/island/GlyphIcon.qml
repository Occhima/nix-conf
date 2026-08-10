import QtQuick
import QtQuick.Shapes

import "root:/data" as Data

Item {
    id: root

    property string name: ""
    property color color: Data.Settings.fgDim
    property real strokeWidth: 1.8

    readonly property var glyphs: ({
        "search": "M11 4a7 7 0 1 0 0 14a7 7 0 1 0 0-14 M16 16l5 5",
        "sun": "M16 12a4 4 0 1 0-8 0a4 4 0 1 0 8 0 M12 2v2 M12 20v2 M4.2 4.2l1.4 1.4 M18.4 18.4l1.4 1.4 M2 12h2 M20 12h2 M4.2 19.8l1.4-1.4 M18.4 5.6l1.4-1.4",
        "cloud": "M17.5 19H9a7 7 0 1 1 6.7-9h1.8a4.5 4.5 0 1 1 0 9z",
        "rain": "M4 15a7 7 0 1 1 11.7-7h1.8a4.5 4.5 0 0 1 2.5 8.2 M8 16v4 M12 16v5 M16 16v4",
        "snow": "M4 15a7 7 0 1 1 11.7-7h1.8a4.5 4.5 0 0 1 2.5 8.2 M8 17h.01 M12 20h.01 M16 17h.01",
        "wifi": "M4 9.5c5-4.7 11-4.7 16 0 M7 13c3-2.8 7-2.8 10 0 M11 17a1.4 1.4 0 1 0 2 0a1.4 1.4 0 1 0-2 0",
        "ethernet": "M5 5h14a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2z M8 20h8 M12 17v3 M8 9v3 M12 9v3 M16 9v3",
        "bluetooth": "M12 3v18 M12 3l5 4.5-10 9 M12 21l5-4.5-10-9",
        "battery": "M5 7h13a2 2 0 0 1 2 2v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2z M20 10h2v4h-2 M7 10h7",
        "bell": "M6 16v-5a6 6 0 0 1 12 0v5 M4 16h16 M10 20a2 2 0 0 0 4 0",
        "mixer": "M6 4v16 M12 4v16 M18 4v16 M3.5 9h5 M9.5 15h5 M15.5 7h5",
        "monitor": "M4 4h16a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z M8 21h8 M12 17v4 M7 13c1.5-4 3-4 5-1s3.5 2 5-2",
        "music": "M9 18V6l12-2v12 M9 18a3 3 0 1 1-6 0a3 3 0 0 1 6 0z M21 16a3 3 0 1 1-6 0a3 3 0 0 1 6 0z",
        "clipboard": "M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2 M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v1a2 2 0 0 1-2 2h-2a2 2 0 0 1-2-2z",
        "image": "M5 3h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z M3 18l5.5-5.5 3 3L16 11l5 5 M16 8h.01",
        "power": "M12 3v9 M7.8 6.3a8 8 0 1 0 8.4 0",
        "close": "M6 6l12 12 M18 6L6 18"
    })

    Shape {
        width: 24
        height: 24
        anchors.centerIn: parent
        scale: Math.min(root.width, root.height) / 24
        transformOrigin: Item.Center
        antialiasing: true

        ShapePath {
            strokeColor: root.color
            fillColor: "transparent"
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.glyphs[root.name] ?? "" }
        }
    }
}
