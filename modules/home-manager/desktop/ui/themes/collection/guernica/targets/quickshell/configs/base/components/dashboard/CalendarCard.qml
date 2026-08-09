import QtQuick
import "root:/data" as Data
import "root:/components/shared" as Shared

Shared.CardFrame {
    Shared.CalendarGrid {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingMd
        displayDate: Data.Time.now
        interactive: false
        mondayStart: true
    }
}
