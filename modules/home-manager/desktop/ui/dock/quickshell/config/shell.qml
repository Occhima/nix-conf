import Quickshell

import "modules" as Modules

ShellRoot {
    Scope {
        Modules.Bar {}
        Modules.Osd {}
        Modules.Notifications {}
        Modules.NotificationCenterPopup {}
        Modules.QuickSettingsPopup {}
        Modules.CalendarPopup {}
        Modules.DashboardPopup {}
        Modules.BluetoothPopup {}
        Modules.NetworkPopup {}
    }
}
