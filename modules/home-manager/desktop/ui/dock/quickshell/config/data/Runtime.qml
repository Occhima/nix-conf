pragma Singleton

import QtQuick

QtObject {
    property bool quickSettingsVisible: false

    function toggleQuickSettings() {
        quickSettingsVisible = !quickSettingsVisible
    }

    function closeAll() {
        quickSettingsVisible = false
    }
}
