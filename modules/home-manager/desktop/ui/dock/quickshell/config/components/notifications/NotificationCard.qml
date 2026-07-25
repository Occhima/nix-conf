import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data
import "root:/services" as Services

Rectangle {
    id: root

    required property var notification
    property bool autoExpire: false
    property bool compact: false

    readonly property color accentColor: Services.Notifications.colorFor(notification)
    readonly property int contentPadding: compact
        ? Data.Settings.spacingMd
        : Data.Settings.notificationPadding
    readonly property int iconSize: compact
        ? 32
        : Data.Settings.notificationIconSize

    signal dismissed()

    implicitHeight: content.implicitHeight + contentPadding * 2
    radius: Data.Settings.notificationRadius
    color: compact ? Data.Settings.bgLight : Data.Settings.notificationSurface
    border.width: 1
    border.color: compact
        ? Data.Settings.borderSubtle
        : Data.Settings.notificationBorder

    scale: cardMouse.pressed ? 0.985 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Data.Settings.animFast
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: 2
        radius: 1
        color: root.accentColor
    }

    MouseArea {
        id: cardMouse

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Services.Notifications.invokeDefault(root.notification)
    }

    ColumnLayout {
        id: content

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: root.contentPadding
            leftMargin: root.contentPadding + 2
        }
        spacing: Data.Settings.spacingSm

        RowLayout {
            Layout.fillWidth: true
            spacing: Data.Settings.spacingSm

            Rectangle {
                Layout.preferredWidth: root.iconSize
                Layout.preferredHeight: Layout.preferredWidth
                radius: 10
                color: Qt.alpha(root.accentColor, 0.13)

                Image {
                    anchors.centerIn: parent
                    width: parent.width - 8
                    height: width
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                    source: Services.Notifications.iconFor(root.notification)
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: root.notification.summary
                    textFormat: Text.PlainText
                    color: Data.Settings.fgColor
                    font.pixelSize: Data.Settings.fontBase
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.notification.appName || root.notification.desktopEntry
                    textFormat: Text.PlainText
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontSm
                    elide: Text.ElideRight
                    visible: text !== ""
                }
            }

            Rectangle {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                radius: 12
                color: closeMouse.containsMouse
                    ? Qt.alpha(Data.Settings.errorColor, 0.18)
                    : "transparent"

                Image {
                    anchors.centerIn: parent
                    width: Data.Settings.iconSm
                    height: width
                    sourceSize: Qt.size(width, height)
                    source: Quickshell.iconPath("window-close-symbolic")
                    opacity: closeMouse.containsMouse ? 1.0 : 0.55

                    Behavior on opacity {
                        NumberAnimation { duration: Data.Settings.animFast }
                    }
                }

                MouseArea {
                    id: closeMouse

                    anchors.fill: parent
                    z: 1
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        mouse.accepted = true;
                        Services.Notifications.dismiss(root.notification);
                        root.dismissed();
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: root.notification.body
            textFormat: Text.PlainText
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontBase
            wrapMode: Text.Wrap
            maximumLineCount: root.compact ? 2 : 4
            elide: Text.ElideRight
            visible: text !== ""
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Data.Settings.spacingSm
            visible: !root.compact && root.notification.actions.length > 0

            Repeater {
                model: Math.min(root.notification.actions.length, 3)

                Rectangle {
                    readonly property var action: root.notification.actions[index]

                    Layout.preferredWidth: actionLabel.implicitWidth + Data.Settings.spacingLg
                    Layout.preferredHeight: 28
                    radius: 9
                    color: actionMouse.containsMouse
                        ? Data.Settings.hoverBg
                        : Data.Settings.bgLight
                    border.width: 1
                    border.color: Data.Settings.borderNormal

                    Text {
                        id: actionLabel

                        anchors.centerIn: parent
                        text: parent.action.text
                        color: Data.Settings.fgColor
                        font.pixelSize: Data.Settings.fontSm
                        font.weight: Font.Medium
                    }

                    MouseArea {
                        id: actionMouse

                        anchors.fill: parent
                        z: 1
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: function(mouse) {
                            mouse.accepted = true;
                            Services.Notifications.hideToast(root.notification);
                            parent.action.invoke();
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }

    Timer {
        id: expirationTimer

        interval: Services.Notifications.timeoutFor(root.notification)
        running: root.autoExpire
        repeat: false
        onTriggered: Services.Notifications.expireToast(root.notification)
    }
}
