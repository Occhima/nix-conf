import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-calendar"
            exclusiveZone: 0
            visible: Data.Runtime.calendarVisible

            anchors { top: true }

            implicitHeight: content.implicitHeight + Data.Settings.barHeight + Data.Settings.barMargin * 2 + 80
            implicitWidth: screen.width
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: panel

                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight + Data.Settings.barMargin * 2 + 12
                    horizontalCenter: parent.horizontalCenter
                }

                width: 320
                height: content.implicitHeight + 40
                color: Data.Settings.bgColorTranslucent
                radius: 24
                border.width: 1
                border.color: Data.Settings.borderNormal
                clip: true
                transformOrigin: Item.Top

                scale: Data.Runtime.calendarVisible ? 1.0 : 0.96
                opacity: Data.Runtime.calendarVisible ? 1.0 : 0.0

                Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 150 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                ColumnLayout {
                    id: content

                    anchors {
                        fill: parent
                        margins: 20
                    }
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: Qt.formatDate(grid.displayDate, "MMMM yyyy")
                            font.pixelSize: 18
                            font.weight: Font.Bold
                            color: Data.Settings.fgColor
                        }

                        Item { Layout.fillWidth: true }

                        NavButton {
                            text: "<"
                            onClicked: grid.displayDate = new Date(grid.displayDate.getFullYear(), grid.displayDate.getMonth() - 1, 1)
                        }

                        NavButton {
                            text: "•"
                            onClicked: grid.displayDate = new Date()
                        }

                        NavButton {
                            text: ">"
                            onClicked: grid.displayDate = new Date(grid.displayDate.getFullYear(), grid.displayDate.getMonth() + 1, 1)
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Repeater {
                            model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

                            Text {
                                Layout.fillWidth: true
                                text: modelData
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 11
                                font.weight: Font.Medium
                                color: Data.Settings.fgDim
                            }
                        }
                    }

                    GridLayout {
                        id: grid

                        Layout.fillWidth: true
                        columns: 7
                        rowSpacing: 4
                        columnSpacing: 0

                        property date displayDate: new Date()
                        property date today: new Date()

                        function isToday(day: int): bool {
                            return day === today.getDate() &&
                                   displayDate.getMonth() === today.getMonth() &&
                                   displayDate.getFullYear() === today.getFullYear()
                        }

                        property var days: {
                            const result = []
                            const d = displayDate
                            const firstDay = new Date(d.getFullYear(), d.getMonth(), 1)
                            const lastDay = new Date(d.getFullYear(), d.getMonth() + 1, 0)
                            const startPad = firstDay.getDay()

                            const prevLast = new Date(d.getFullYear(), d.getMonth(), 0).getDate()
                            for (let i = startPad - 1; i >= 0; i--)
                                result.push({ day: prevLast - i, current: false })

                            for (let i = 1; i <= lastDay.getDate(); i++)
                                result.push({ day: i, current: true })

                            const remaining = 42 - result.length
                            for (let i = 1; i <= remaining; i++)
                                result.push({ day: i, current: false })

                            return result
                        }

                        Repeater {
                            model: grid.days

                            Rectangle {
                                required property var modelData

                                readonly property bool isToday: modelData.current && grid.isToday(modelData.day)

                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                radius: 16
                                color: isToday ? Data.Settings.accentColor : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.day
                                    font.pixelSize: 13
                                    font.weight: isToday ? Font.Bold : Font.Normal
                                    color: !modelData.current ? Data.Settings.fgDim :
                                           isToday ? Data.Settings.bgColor : Data.Settings.fgColor
                                }
                            }
                        }
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
        color: mouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight

        Behavior on color { ColorAnimation { duration: 150 } }

        Text {
            anchors.centerIn: parent
            text: parent.text
            font.pixelSize: 14
            font.weight: Font.Bold
            color: Data.Settings.fgColor
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: parent.clicked()
        }
    }
}
