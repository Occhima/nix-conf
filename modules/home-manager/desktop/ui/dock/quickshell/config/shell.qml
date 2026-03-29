import Quickshell
import Quickshell.Io
import QtQuick

import "modules" as Modules
import "services" as Services
import "data" as Data

ShellRoot {
    Scope {
        Modules.Bar {}
        Modules.Osd {}
        Modules.QuickSettingsPopup {}
        Modules.CalendarPopup {}
        Modules.DashboardPopup {}
        Modules.BluetoothPopup {}
        Modules.NetworkPopup {}
    }
}
