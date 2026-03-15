pragma Singleton

import QtQuick

QtObject {
    property bool calendarVisible: false
    property bool quickSettingsVisible: false

    function toggleCalendar() {
        quickSettingsVisible = false
        calendarVisible = !calendarVisible
    }

    function toggleQuickSettings() {
        calendarVisible = false
        quickSettingsVisible = !quickSettingsVisible
    }

    function closeAll() {
        calendarVisible = false
        quickSettingsVisible = false
    }
}
