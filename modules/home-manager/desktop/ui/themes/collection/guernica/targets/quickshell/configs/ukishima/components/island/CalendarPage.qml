import QtQuick
import QtQuick.Layouts

import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    property date displayDate: Data.Time.now
    readonly property date today: Data.Time.now

    function isToday(cell): bool {
        return cell.current
            && cell.day === today.getDate()
            && displayDate.getMonth() === today.getMonth()
            && displayDate.getFullYear() === today.getFullYear()
    }

    readonly property var calendarCells: {
        const year = displayDate.getFullYear()
        const month = displayDate.getMonth()
        const first = new Date(year, month, 1)
        const last = new Date(year, month + 1, 0)
        const startPad = (first.getDay() + 6) % 7
        const previousLast = new Date(year, month, 0).getDate()
        const cells = []

        for (let index = startPad - 1; index >= 0; index--)
            cells.push({ day: previousLast - index, current: false })
        for (let day = 1; day <= last.getDate(); day++)
            cells.push({ day: day, current: true })
        while (cells.length < 42)
            cells.push({ day: cells.length - last.getDate() - startPad + 1, current: false })
        return cells
    }

    RowLayout {
        anchors.fill: parent
        spacing: 14

        ColumnLayout {
            Layout.preferredWidth: 150
            Layout.fillHeight: true
            spacing: 3

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: Services.Weather.symbolFor(Services.Weather.description)
                    color: Data.Settings.warmAccent
                    font.pixelSize: 25
                }
                Text {
                    text: Services.Weather.temperature
                    color: Data.Settings.fgColor
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                }
            }

            Text {
                Layout.fillWidth: true
                text: Services.Weather.city.toUpperCase()
                color: Data.Settings.fgDim
                font.family: "monospace"
                font.pixelSize: Data.Settings.fontXs
                font.letterSpacing: 1.1
                elide: Text.ElideRight
            }
            Text {
                Layout.fillWidth: true
                text: Services.Weather.description + "  ·  " + Services.Weather.humidity
                color: Data.Settings.fgDim
                font.pixelSize: Data.Settings.fontXs
                elide: Text.ElideRight
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                Layout.topMargin: 5
                Layout.bottomMargin: 5
                color: Data.Settings.hairline
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                Repeater {
                    model: Services.Weather.forecast

                    ColumnLayout {
                        required property var modelData

                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: {
                                const date = new Date(parent.modelData.date + "T00:00:00")
                                return isNaN(date.getTime()) ? "--" : Qt.formatDate(date, "ddd").slice(0, 1)
                            }
                            color: Data.Settings.fgDim
                            font.family: "monospace"
                            font.pixelSize: Data.Settings.fontXs
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: parent.modelData.symbol
                            color: Data.Settings.fgColor
                            font.pixelSize: Data.Settings.fontSm
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: parent.modelData.high.replace("°", "")
                            color: Data.Settings.fgDim
                            font.family: "monospace"
                            font.pixelSize: Data.Settings.fontXs
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            color: Data.Settings.hairline
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 22

                Text {
                    text: Qt.formatDate(root.displayDate, "MMMM yyyy").toUpperCase()
                    color: Data.Settings.fgColor
                    font.family: "monospace"
                    font.pixelSize: Data.Settings.fontSm
                    font.weight: Font.DemiBold
                }

                Item { Layout.fillWidth: true }

                NavButton {
                    text: "‹"
                    onClicked: root.displayDate = new Date(
                        root.displayDate.getFullYear(),
                        root.displayDate.getMonth() - 1,
                        1
                    )
                }
                NavButton {
                    text: "›"
                    onClicked: root.displayDate = new Date(
                        root.displayDate.getFullYear(),
                        root.displayDate.getMonth() + 1,
                        1
                    )
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 14
                spacing: 0

                Repeater {
                    model: ["M", "T", "W", "T", "F", "S", "S"]
                    Text {
                        Layout.fillWidth: true
                        text: modelData
                        horizontalAlignment: Text.AlignHCenter
                        color: Data.Settings.fgDim
                        font.family: "monospace"
                        font.pixelSize: Data.Settings.fontXs
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 7
                rowSpacing: 1
                columnSpacing: 0

                Repeater {
                    model: root.calendarCells

                    Rectangle {
                        required property var modelData

                        readonly property bool todayCell: root.isToday(modelData)

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 10
                        color: todayCell
                            ? Qt.alpha(Data.Settings.warmAccent, 0.84)
                            : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: String(parent.modelData.day)
                            color: !parent.modelData.current
                                ? Qt.alpha(Data.Settings.fgDim, 0.45)
                                : parent.todayCell
                                    ? Data.Settings.bgColor
                                    : Data.Settings.fgColor
                            font.family: "monospace"
                            font.pixelSize: Data.Settings.fontXs
                            font.weight: parent.todayCell ? Font.Bold : Font.Normal
                        }
                    }
                }
            }
        }
    }

    component NavButton: Rectangle {
        id: button

        required property string text
        signal clicked()

        Layout.preferredWidth: 22
        Layout.preferredHeight: 22
        radius: 5
        color: navMouse.containsMouse ? Data.Settings.hoverBg : "transparent"

        Text {
            anchors.centerIn: parent
            text: button.text
            color: Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontBase
        }

        MouseArea {
            id: navMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }
}
