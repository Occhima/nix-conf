pragma Singleton

import QtQuick

QtObject {
    property string activePopup: ""

    readonly property bool quickSettingsVisible: activePopup === "quickSettings"
    readonly property bool calendarVisible: activePopup === "calendar"
    readonly property bool dashboardVisible: activePopup === "dashboard"
    readonly property bool bluetoothVisible: activePopup === "bluetooth"
    property bool networkPopupVisible: false

    function toggle(name: string): void {
        activePopup = activePopup === name ? "" : name
    }

    function toggleQuickSettings(): void { toggle("quickSettings") }
    function toggleCalendar(): void { toggle("calendar") }
    function toggleDashboard(): void { toggle("dashboard") }
    function toggleBluetooth(): void { toggle("bluetooth") }
    function setNetworkPopupVisible(visible: bool): void { networkPopupVisible = visible }
    function closeAll(): void {
        activePopup = ""
        networkPopupVisible = false
    }
}
