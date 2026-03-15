pragma Singleton

import QtQuick

QtObject {
    property bool quickSettingsVisible: false
    property bool calendarVisible: false

    function toggleQuickSettings() {
        calendarVisible = false
        quickSettingsVisible = !quickSettingsVisible
    }

    function toggleCalendar() {
        quickSettingsVisible = false
        calendarVisible = !calendarVisible
    }

    function closeAll() {
        quickSettingsVisible = false
        calendarVisible = false
    }
}
