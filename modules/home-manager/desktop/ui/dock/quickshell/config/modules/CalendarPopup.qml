import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data

Scope {
    id: calendarScope

    readonly property int animShort: 150
    readonly property int animMedium: 250

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
            }

            // Center horizontally
            implicitHeight: calendarPanel.height + Data.Settings.barHeight + Data.Settings.barMargin * 2 + 16
            implicitWidth: screen.width

            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Data.Runtime.closeAll()
            }

            Rectangle {
                id: calendarPanel
                anchors {
                    top: parent.top
                    topMargin: Data.Settings.barHeight + Data.Settings.barMargin * 2 + 12
                    horizontalCenter: parent.horizontalCenter
                }
                width: 320
                height: calendarContent.implicitHeight + 40
                color: Data.Settings.bgColorTranslucent
                radius: 24
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.08)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                scale: Data.Runtime.calendarVisible ? 1.0 : 0.94
                opacity: Data.Runtime.calendarVisible ? 1.0 : 0

                Behavior on scale {
                    NumberAnimation { duration: calendarScope.animMedium; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: calendarScope.animShort }
                }

                transformOrigin: Item.Top

                ColumnLayout {
                    id: calendarContent
                    anchors {
                        fill: parent
                        margins: 20
                    }
                    spacing: 16

                    // Month/Year header with navigation
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            id: monthYearText
                            text: {
                                const d = calendarGrid.displayDate;
                                return Qt.formatDate(d, "MMMM yyyy");
                            }
                            font.pixelSize: 18
                            font.weight: Font.Bold
                            color: Data.Settings.fgColor
                        }

                        Item { Layout.fillWidth: true }

                        NavButton {
                            text: "<"
                            onClicked: {
                                const d = calendarGrid.displayDate;
                                calendarGrid.displayDate = new Date(d.getFullYear(), d.getMonth() - 1, 1);
                            }
                        }

                        NavButton {
                            text: "•"
                            onClicked: calendarGrid.displayDate = new Date()
                        }

                        NavButton {
                            text: ">"
                            onClicked: {
                                const d = calendarGrid.displayDate;
                                calendarGrid.displayDate = new Date(d.getFullYear(), d.getMonth() + 1, 1);
                            }
                        }
                    }

                    // Day headers
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

                    // Calendar grid
                    GridLayout {
                        id: calendarGrid
                        Layout.fillWidth: true
                        columns: 7
                        rowSpacing: 4
                        columnSpacing: 0

                        property date displayDate: new Date()
                        property date today: new Date()

                        property var days: {
                            const result = [];
                            const d = displayDate;
                            const firstDay = new Date(d.getFullYear(), d.getMonth(), 1);
                            const lastDay = new Date(d.getFullYear(), d.getMonth() + 1, 0);
                            const startPad = firstDay.getDay();

                            // Previous month days
                            const prevLast = new Date(d.getFullYear(), d.getMonth(), 0).getDate();
                            for (let i = startPad - 1; i >= 0; i--) {
                                result.push({ day: prevLast - i, current: false });
                            }

                            // Current month days
                            for (let i = 1; i <= lastDay.getDate(); i++) {
                                result.push({ day: i, current: true });
                            }

                            // Next month days
                            const remaining = 42 - result.length;
                            for (let i = 1; i <= remaining; i++) {
                                result.push({ day: i, current: false });
                            }

                            return result;
                        }

                        Repeater {
                            model: calendarGrid.days

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                radius: 16
                                color: {
                                    if (!modelData.current) return "transparent";
                                    const t = calendarGrid.today;
                                    const d = calendarGrid.displayDate;
                                    if (modelData.day === t.getDate() &&
                                        d.getMonth() === t.getMonth() &&
                                        d.getFullYear() === t.getFullYear()) {
                                        return Data.Settings.accentColor;
                                    }
                                    return "transparent";
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.day
                                    font.pixelSize: 13
                                    font.weight: {
                                        const t = calendarGrid.today;
                                        const d = calendarGrid.displayDate;
                                        if (modelData.current && modelData.day === t.getDate() &&
                                            d.getMonth() === t.getMonth() &&
                                            d.getFullYear() === t.getFullYear()) {
                                            return Font.Bold;
                                        }
                                        return Font.Normal;
                                    }
                                    color: {
                                        if (!modelData.current) return Data.Settings.fgDim;
                                        const t = calendarGrid.today;
                                        const d = calendarGrid.displayDate;
                                        if (modelData.day === t.getDate() &&
                                            d.getMonth() === t.getMonth() &&
                                            d.getFullYear() === t.getFullYear()) {
                                            return Data.Settings.bgColor;
                                        }
                                        return Data.Settings.fgColor;
                                    }
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
        color: navMouse.containsMouse ? Data.Settings.bgLighter : Data.Settings.bgLight

        Behavior on color {
            ColorAnimation { duration: calendarScope.animShort }
        }

        Text {
            anchors.centerIn: parent
            text: parent.text
            font.pixelSize: 14
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
