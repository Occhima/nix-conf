import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data
import "root:/components/shared" as Shared

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
                radius: Data.Settings.popupRadius
                border.width: 1
                border.color: Data.Settings.borderNormal
                clip: true
                transformOrigin: Item.Top

                scale: Data.Runtime.calendarVisible ? 1.0 : Data.Settings.popupScaleHidden
                opacity: Data.Runtime.calendarVisible ? 1.0 : 0.0

                Behavior on scale { NumberAnimation { duration: Data.Settings.animMedium; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: Data.Settings.animShort } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse.accepted = true
                }

                Shared.CalendarGrid {
                    id: content

                    anchors {
                        fill: parent
                        margins: Data.Settings.spacingXl
                    }

                    interactive: true
                    mondayStart: false
                }
            }
        }
    }
}
