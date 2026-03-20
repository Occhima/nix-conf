import QtQuick
import QtQuick.Layouts
import "root:/data" as Data

Item {
    id: root

    property date displayDate: new Date()
    property bool interactive: false
    property bool mondayStart: true

    implicitHeight: column.implicitHeight

    readonly property date today: new Date()

    function isToday(day) {
        return day === today.getDate() &&
               displayDate.getMonth() === today.getMonth() &&
               displayDate.getFullYear() === today.getFullYear()
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: Data.Settings.spacingSm

        RowLayout {
            Layout.fillWidth: true
            spacing: Data.Settings.spacingSm
            visible: root.interactive

            Text {
                text: Qt.formatDate(root.displayDate, "MMMM yyyy")
                font.pixelSize: Data.Settings.fontXl
                font.weight: Font.Bold
                color: Data.Settings.fgColor
            }

            Item { Layout.fillWidth: true }

            NavButton {
                text: "<"
                onClicked: root.displayDate = new Date(root.displayDate.getFullYear(), root.displayDate.getMonth() - 1, 1)
            }

            NavButton {
                text: "\u2022"
                onClicked: root.displayDate = new Date()
            }

            NavButton {
                text: ">"
                onClicked: root.displayDate = new Date(root.displayDate.getFullYear(), root.displayDate.getMonth() + 1, 1)
            }
        }

        Text {
            Layout.fillWidth: true
            visible: !root.interactive
            text: Qt.formatDate(root.displayDate, "MMMM yyyy")
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontLg
            font.weight: Font.DemiBold
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            Repeater {
                model: root.mondayStart
                    ? ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    : ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

                Text {
                    Layout.fillWidth: true
                    text: modelData
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Data.Settings.fontSm
                    font.weight: Font.Medium
                    color: Data.Settings.fgDim
                }
            }
        }

        GridLayout {
            id: grid

            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            rowSpacing: Data.Settings.spacingXs
            columnSpacing: 0

            property var cells: {
                const year = root.displayDate.getFullYear()
                const month = root.displayDate.getMonth()
                const first = new Date(year, month, 1)
                const last = new Date(year, month + 1, 0)

                const startPad = root.mondayStart
                    ? (first.getDay() + 6) % 7
                    : first.getDay()

                const prevLast = new Date(year, month, 0).getDate()

                const out = []

                for (let i = startPad - 1; i >= 0; i--)
                    out.push({ day: prevLast - i, current: false })

                for (let i = 1; i <= last.getDate(); i++)
                    out.push({ day: i, current: true })

                while (out.length < 42)
                    out.push({ day: out.length - last.getDate() - startPad + 1, current: false })

                return out
            }

            Repeater {
                model: grid.cells

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.interactive ? 32 : 24
                    radius: height / 2

                    readonly property bool isTodayCell: modelData.current && root.isToday(modelData.day)

                    color: isTodayCell
                        ? (root.interactive ? Data.Settings.accentColor : Qt.alpha(Data.Settings.warningColor, 0.85))
                        : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: String(modelData.day)
                        color: {
                            if (!modelData.current)
                                return Qt.alpha(Data.Settings.fgDim, 0.7)
                            return isTodayCell ? Data.Settings.bgColor : Data.Settings.fgColor
                        }
                        font.pixelSize: Data.Settings.fontSm
                        font.weight: isTodayCell ? Font.Bold : Font.Normal
                    }
                }
            }
        }
    }

    component NavButton: Rectangle {
        property string text
        signal clicked()

        width: 28
        height: 28
        radius: 14
        color: navMouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight

        Behavior on color { ColorAnimation { duration: Data.Settings.animShort } }

        Text {
            anchors.centerIn: parent
            text: parent.text
            font.pixelSize: Data.Settings.fontLg
            font.weight: Font.Bold
            color: Data.Settings.fgColor
        }

        MouseArea {
            id: navMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: parent.clicked()
        }
    }
}
