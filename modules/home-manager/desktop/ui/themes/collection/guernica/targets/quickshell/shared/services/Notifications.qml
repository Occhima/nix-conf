pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import "root:/data" as Data

Singleton {
    id: root

    readonly property bool enabled: Data.Settings.notificationsEnabled
    property bool dnd: false
    property var items: []
    property var toasts: []

    readonly property int count: items.length
    readonly property bool hasNotifications: count > 0
    readonly property bool hasCritical: items.some(item =>
        item && item.urgency === NotificationUrgency.Critical)
    readonly property int maxHistory: 30
    readonly property int maxToasts: 4
    readonly property alias historyModel: historyModelSource
    readonly property alias toastModel: toastModelSource
    readonly property string icon: dnd
        ? "notifications-disabled-symbolic"
        : "preferences-system-notifications-symbolic"

    function isSuppressed(notification: Notification): bool {
        const source = `${notification.appName} ${notification.desktopEntry}`.toLowerCase();
        const syncError = notification.summary.trim().toLowerCase() === "sync error";
        const failedUpload = notification.body.trim().toLowerCase().startsWith("could not upload");
        return syncError && (source.includes("maestral") || failedUpload);
    }

    function remember(notification: Notification): void {
        items = [
            notification,
            ...items.filter(item => item !== notification)
        ];

        if (items.length > maxHistory) {
            const expired = items.slice(maxHistory);
            items = items.slice(0, maxHistory);
            expired.forEach(item => item.expire());
        }
    }

    function showToast(notification: Notification): void {
        const next = [
            notification,
            ...toasts.filter(item => item !== notification)
        ];
        const overflow = next.slice(maxToasts);

        toasts = next.slice(0, maxToasts);
        overflow
            .filter(item => item.transient)
            .forEach(item => item.expire());
    }

    function forget(notification: Notification): void {
        items = items.filter(item => item !== notification);
        toasts = toasts.filter(item => item !== notification);
    }

    function hideToast(notification: Notification): void {
        toasts = toasts.filter(item => item !== notification);
    }

    function expireToast(notification: Notification): void {
        hideToast(notification);
        if (notification.transient) {
            notification.expire();
        }
    }

    function dismiss(notification: Notification): void {
        forget(notification);
        notification.dismiss();
    }

    function clearAll(): void {
        const notifications = [...items];
        items = [];
        toasts = [];
        notifications.forEach(notification => notification.dismiss());
    }

    function toggleDnd(): void {
        dnd = !dnd;
        if (dnd) {
            const transientToasts = toasts.filter(item => item.transient);
            toasts = [];
            transientToasts.forEach(notification => notification.expire());
        }
    }

    function timeoutFor(notification): int {
        if (!notification) {
            return 6000;
        }
        if (notification.expireTimeout > 0) {
            return Math.max(2000, notification.expireTimeout * 1000);
        }

        return notification.urgency === NotificationUrgency.Critical ? 10000 : 6000;
    }

    function iconFor(notification): string {
        if (!notification) {
            return Quickshell.iconPath("dialog-information-symbolic");
        }
        if (notification.image !== "") {
            return notification.image;
        }

        const icon = notification.appIcon;
        if (icon === "") {
            return Quickshell.iconPath("dialog-information-symbolic");
        }
        if (icon.startsWith("/") || icon.startsWith("file:")) {
            return icon;
        }
        return Quickshell.iconPath(icon);
    }

    function colorFor(notification): color {
        if (!notification) {
            return Data.Settings.accentColor;
        }
        switch (notification.urgency) {
        case NotificationUrgency.Critical:
            return Data.Settings.errorColor;
        case NotificationUrgency.Low:
            return Data.Settings.fgDim;
        default:
            return Data.Settings.accentColor;
        }
    }

    function invokeDefault(notification: Notification): void {
        const actions = notification.actions;
        for (let index = 0; index < actions.length; index++) {
            if (actions[index].identifier === "default") {
                hideToast(notification);
                actions[index].invoke();
                return;
            }
        }

        dismiss(notification);
    }

    ScriptModel {
        id: historyModelSource
        values: root.items
    }

    ScriptModel {
        id: toastModelSource
        values: root.toasts
    }

    LazyLoader {
        active: root.enabled

        NotificationServer {
            keepOnReload: true
            bodySupported: true
            bodyMarkupSupported: false
            imageSupported: true
            actionsSupported: true
            persistenceSupported: true

            onNotification: notification => {
                if (root.isSuppressed(notification)) {
                    notification.dismiss();
                    return;
                }
                if (notification.transient && (root.dnd || notification.lastGeneration)) {
                    notification.expire();
                    return;
                }

                notification.tracked = true;
                notification.closed.connect(() => root.forget(notification));

                if (!notification.transient) {
                    root.remember(notification);
                }
                if (!root.dnd && !notification.lastGeneration) {
                    root.showToast(notification);
                }
            }
        }
    }
}
