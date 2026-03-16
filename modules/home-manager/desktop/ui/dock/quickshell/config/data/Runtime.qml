pragma Singleton

import QtQuick

QtObject {
    property bool quickSettingsVisible: false
    property bool calendarVisible: false
    property bool dashboardVisible: false
    property bool bluetoothVisible: false


    function toggleQuickSettings() {
        dashboardVisible = false
        bluetoothVisible = false
        calendarVisible = false
        quickSettingsVisible = !quickSettingsVisible
    }

    function toggleCalendar() {

        dashboardVisible = false
        bluetoothVisible = false
        quickSettingsVisible = false
        calendarVisible = !calendarVisible
    }

    function toggleDashboard() {
        calendarVisible = false
        quickSettingsVisible = false
        bluetoothVisible = false
        dashboardVisible = !dashboardVisible
    }

    function toggleBluetooth() {
        calendarVisible = false
        quickSettingsVisible = false
        dashboardVisible = false
        bluetoothVisible = !bluetoothVisible
    }

    function closeAll() {
        quickSettingsVisible = false
        calendarVisible = false
        dashboardVisible = false
        bluetoothVisible = false
    }
}
