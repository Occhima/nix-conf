pragma Singleton

import QtQuick

QtObject {
    property string activePopup: ""

    readonly property bool quickSettingsVisible: activePopup === "quickSettings"
    readonly property bool calendarVisible: activePopup === "calendar"
    readonly property bool dashboardVisible: activePopup === "dashboard"
    readonly property bool bluetoothVisible: activePopup === "bluetooth"

    function toggle(name: string): void {
        activePopup = activePopup === name ? "" : name
    }

    function toggleQuickSettings(): void { toggle("quickSettings") }
    function toggleCalendar(): void { toggle("calendar") }
    function toggleDashboard(): void { toggle("dashboard") }
    function toggleBluetooth(): void { toggle("bluetooth") }
    function closeAll(): void { activePopup = "" }
}
