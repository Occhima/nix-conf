pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

QtObject {
    readonly property UPowerDevice battery: UPower.displayDevice

    readonly property bool hasBattery: battery !== null && battery.isPresent
    readonly property real percentage: battery?.percentage ?? 0
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging
    readonly property bool fullyCharged: battery?.state === UPowerDeviceState.FullyCharged

    readonly property string icon: {
        if (!hasBattery) return "battery-missing-symbolic";
        const level = Math.round(percentage / 10) * 10;
        const prefix = "battery";
        const chargingSuffix = charging ? "-charging" : "";
        if (fullyCharged) return "battery-full-charged-symbolic";
        if (level <= 10) return prefix + "-empty" + chargingSuffix + "-symbolic";
        if (level <= 30) return prefix + "-low" + chargingSuffix + "-symbolic";
        if (level <= 60) return prefix + "-medium" + chargingSuffix + "-symbolic";
        if (level <= 90) return prefix + "-good" + chargingSuffix + "-symbolic";
        return prefix + "-full" + chargingSuffix + "-symbolic";
    }

    readonly property string tooltip: {
        if (!hasBattery) return "No battery";
        const status = charging ? "Charging" : fullyCharged ? "Full" : "Discharging";
        return Math.round(percentage) + "% - " + status;
    }
}
