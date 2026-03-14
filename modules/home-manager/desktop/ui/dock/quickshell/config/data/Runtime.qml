pragma Singleton

import QtQuick

QtObject {
    property bool quickSettingsOpen: false

    function toggleQuickSettings() {
        quickSettingsOpen = !quickSettingsOpen;
    }
}
