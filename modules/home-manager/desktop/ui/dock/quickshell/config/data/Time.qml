pragma Singleton

import Quickshell
import QtQuick

QtObject {
    readonly property string time: {
        const now = new Date();
        let hours = now.getHours();
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const ampm = hours >= 12 ? "PM" : "AM";
        hours = hours % 12 || 12;
        return String(hours).padStart(2, '0') + "\n" + minutes;
    }

    property var timer: Timer {
        interval: 60000 - (Date.now() % 60000)
        running: true
        repeat: true
        onTriggered: {
            interval = 60000;
            time;
        }
    }
}
