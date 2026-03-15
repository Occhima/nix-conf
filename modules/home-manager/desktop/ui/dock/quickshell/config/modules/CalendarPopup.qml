import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data

Scope {
    id: calendarScope

    property date currentDate: new Date()
    property date viewDate: new Date()

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    function firstDayOfMonth(year, month) {
        // Returns 0-6 (Sun-Sat), adjust for Monday start
        const day = new Date(year, month, 1).getDay()
        return day === 0 ? 6 : day - 1
    }

    function resetToToday() {
        viewDate = new Date()
    }

    function previousMonth() {
        const d = new Date(viewDate)
        d.setMonth(d.getMonth() - 1)
        viewDate = d
    }

    function nextMonth() {
        const d = new Date(viewDate)
        d.setMonth(d.getMonth() + 1)
        viewDate = d
    }

    // Update current time
    Timer {
        interval: 1000
        running: Data.Runtime.calendarVisible
        repeat: true
        onTriggered: currentDate = new Date()
    }

    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-calendar"
            exclusiveZone: 0
            visible: Data.Runtime.calendarVisible

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: dashboardContent.height + Data.Settings.barHeight + Data.Settings.barMargin * 2 + 16
            implicitWidth: screen.width

            color: "transparent"

            // Click outside to close
            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: dashboardContent
                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight + Data.Settings.barMargin * 2 + 12
                    horizontalCenter: parent.horizontalCenter
                }
                width: dashboardLayout.implicitWidth + 32
                height: dashboardLayout.implicitHeight + 32
                color: Data.Settings.bgColor
                radius: Data.Settings.rounding + 4
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.06)

                // Subtle shadow effect
                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        color: "transparent"
                        radius: parent.radius + 2
                        border.width: 1
                        border.color: Qt.rgba(0, 0, 0, 0.3)
                    }
                }

                // Prevent clicks from closing
                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                    onWheel: wheel => {
                        if (wheel.angleDelta.y > 0) {
                            calendarScope.previousMonth()
                        } else {
                            calendarScope.nextMonth()
                        }
                    }
                }

                RowLayout {
                    id: dashboardLayout
                    anchors {
                        fill: parent
                        margins: 16
                    }
                    spacing: 16

                    // Left: Large time display (Caelestia style)
                    Rectangle {
                        Layout.preferredWidth: 90
                        Layout.fillHeight: true
                        color: Data.Settings.bgLight
                        radius: Data.Settings.rounding

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: -8

                            // Hour
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: {
                                    const h = calendarScope.currentDate.getHours()
                                    return h.toString().padStart(2, '0')
                                }
                                color: Data.Settings.fgColor
                                font.pixelSize: 42
                                font.weight: Font.DemiBold
                                font.family: "monospace"
                            }

                            // Separator dots
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "\u2022\u2022\u2022"
                                color: Data.Settings.accentColor
                                font.pixelSize: 16
                                font.letterSpacing: 2
                            }

                            // Minute
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: {
                                    const m = calendarScope.currentDate.getMinutes()
                                    return m.toString().padStart(2, '0')
                                }
                                color: Data.Settings.fgColor
                                font.pixelSize: 42
                                font.weight: Font.DemiBold
                                font.family: "monospace"
                            }

                            // Date string
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.topMargin: 8
                                text: calendarScope.currentDate.toLocaleDateString(Qt.locale(), "ddd, d")
                                color: Data.Settings.fgDim
                                font.pixelSize: 12
                                font.weight: Font.Medium
                            }
                        }
                    }

                    // Right: Calendar grid
                    Rectangle {
                        Layout.preferredWidth: 280
                        Layout.fillHeight: true
                        color: Data.Settings.bgLight
                        radius: Data.Settings.rounding

                        ColumnLayout {
                            anchors {
                                fill: parent
                                margins: 16
                            }
                            spacing: 12

                            // Header: Month navigation
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                // Previous month button
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: prevMouseArea.containsMouse ? Data.Settings.bgLighter : "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "\u276E"
                                        color: Data.Settings.fgDim
                                        font.pixelSize: 12
                                    }

                                    MouseArea {
                                        id: prevMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: calendarScope.previousMonth()
                                    }
                                }

                                // Month + Year
                                Item {
                                    Layout.fillWidth: true
                                    height: 28

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: monthText.implicitWidth + 16
                                        height: 24
                                        radius: 12
                                        color: monthMouseArea.containsMouse ? Data.Settings.bgLighter : "transparent"

                                        Text {
                                            id: monthText
                                            anchors.centerIn: parent
                                            text: calendarScope.viewDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")
                                            color: Data.Settings.accentColor
                                            font.pixelSize: 13
                                            font.weight: Font.Medium
                                        }

                                        MouseArea {
                                            id: monthMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: calendarScope.resetToToday()
                                        }
                                    }
                                }

                                // Next month button
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: nextMouseArea.containsMouse ? Data.Settings.bgLighter : "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "\u276F"
                                        color: Data.Settings.fgDim
                                        font.pixelSize: 12
                                    }

                                    MouseArea {
                                        id: nextMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: calendarScope.nextMonth()
                                    }
                                }
                            }

                            // Day headers (Mon-Sun)
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Repeater {
                                    model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData
                                        color: (index >= 5) ? Data.Settings.accentColor : Data.Settings.fgDim
                                        font.pixelSize: 11
                                        font.weight: Font.Medium
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }

                            // Calendar grid
                            Grid {
                                Layout.fillWidth: true
                                columns: 7
                                spacing: 4

                                Repeater {
                                    model: 42 // 6 weeks max

                                    Rectangle {
                                        property int dayOffset: index - calendarScope.firstDayOfMonth(calendarScope.viewDate.getFullYear(), calendarScope.viewDate.getMonth())
                                        property int dayNumber: dayOffset + 1
                                        property bool isCurrentMonth: dayNumber > 0 && dayNumber <= calendarScope.daysInMonth(calendarScope.viewDate.getFullYear(), calendarScope.viewDate.getMonth())
                                        property bool isToday: isCurrentMonth &&
                                            dayNumber === calendarScope.currentDate.getDate() &&
                                            calendarScope.viewDate.getMonth() === calendarScope.currentDate.getMonth() &&
                                            calendarScope.viewDate.getFullYear() === calendarScope.currentDate.getFullYear()
                                        property bool isWeekend: (index % 7 >= 5)

                                        width: (parent.width - 24) / 7
                                        height: 32
                                        radius: 8
                                        color: isToday ? Data.Settings.accentColor :
                                               dayMouseArea.containsMouse && isCurrentMonth ? Data.Settings.bgLighter : "transparent"

                                        MouseArea {
                                            id: dayMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: parent.isCurrentMonth
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: {
                                                if (!parent.isCurrentMonth) {
                                                    if (parent.dayNumber <= 0) {
                                                        const prevMonth = new Date(calendarScope.viewDate)
                                                        prevMonth.setMonth(prevMonth.getMonth() - 1)
                                                        const daysInPrev = calendarScope.daysInMonth(prevMonth.getFullYear(), prevMonth.getMonth())
                                                        return daysInPrev + parent.dayNumber
                                                    } else {
                                                        const daysInCurrent = calendarScope.daysInMonth(calendarScope.viewDate.getFullYear(), calendarScope.viewDate.getMonth())
                                                        return parent.dayNumber - daysInCurrent
                                                    }
                                                }
                                                return parent.dayNumber
                                            }
                                            color: {
                                                if (parent.isToday) return Data.Settings.bgColor
                                                if (!parent.isCurrentMonth) return Data.Settings.fgDim
                                                if (parent.isWeekend) return Data.Settings.accentColor
                                                return Data.Settings.fgColor
                                            }
                                            font.pixelSize: 12
                                            font.weight: parent.isToday ? Font.Bold : Font.Normal
                                            opacity: parent.isCurrentMonth ? 1.0 : 0.3
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
