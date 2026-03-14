pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

QtObject {
    property bool dnd: false
    property list<Notification> items: []

    signal newNotification(Notification notification)

    property var server: NotificationServer {
        onNotification: notification => {
            if (dnd) {
                notification.dismiss();
                return;
            }
            items = [notification, ...items];
            newNotification(notification);
        }
    }

    function dismiss(index) {
        if (index >= 0 && index < items.length) {
            items[index].dismiss();
            items = items.filter((_, i) => i !== index);
        }
    }

    function clearAll() {
        items.forEach(n => n.dismiss());
        items = [];
    }

    function toggleDnd() {
        dnd = !dnd;
    }

    readonly property int count: items.length

    readonly property string icon: dnd
        ? "notifications-disabled-symbolic"
        : "preferences-system-notifications-symbolic"
}
