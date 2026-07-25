pragma Singleton

import Quickshell

Singleton {
    readonly property date now: clock.date
    readonly property string hours: String(clock.hours).padStart(2, "0")
    readonly property string minutes: String(clock.minutes).padStart(2, "0")
    readonly property string time: Qt.formatDateTime(clock.date, "hh:mm")
    readonly property string stackedTime: hours + "\n" + minutes
    readonly property string shortDate: Qt.formatDate(clock.date, "ddd, d")
    readonly property string barDate: Qt.formatDate(clock.date, "ddd d")
    readonly property string longDate: Qt.formatDate(clock.date, "dddd, MMMM d")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
