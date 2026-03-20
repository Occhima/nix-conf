import QtQuick
import "root:/data" as Data
import "root:/components/shared" as Shared

Shared.CardFrame {
    id: root

    property date currentTime: new Date()

    Shared.CalendarGrid {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingMd
        displayDate: root.currentTime
        interactive: false
        mondayStart: true
    }
}
