import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    readonly property var activePlayer: {
        const players = Mpris.players.values
        for (let i = 0; i < players.length; i++)
            if (players[i] && players[i].isPlaying) return players[i]
        return players.length > 0 ? players[0] : null
    }
    readonly property real progress: {
        const player = activePlayer
        if (!player || !player.length || player.length <= 0) return 0
        return Data.Utils.clamp01(player.position / player.length)
    }

    RowLayout {
        anchors.fill: parent
        spacing: Data.Settings.spacingLg

        Rectangle {
            Layout.preferredWidth: 78
            Layout.fillHeight: true
            radius: 18
            clip: true
            color: Data.Settings.bgLight

            Image {
                id: artwork
                anchors.fill: parent
                source: Data.Utils.safeUrl(root.activePlayer?.trackArtUrl)
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }

            Text {
                anchors.centerIn: parent
                visible: artwork.status !== Image.Ready
                text: "音"
                color: Data.Settings.warmAccent
                font.pixelSize: 30
                font.weight: Font.DemiBold
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Text {
                Layout.fillWidth: true
                text: Data.Utils.safeString(root.activePlayer?.trackTitle, "Nothing playing")
                color: Data.Settings.fgColor
                font.pixelSize: Data.Settings.fontLg
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: Data.Utils.safeString(root.activePlayer?.trackArtist, "Start an MPRIS player")
                color: Data.Settings.fgDim
                font.pixelSize: Data.Settings.fontSm
                elide: Text.ElideRight
            }

            Item { Layout.fillHeight: true }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 4
                radius: 2
                color: Data.Settings.bgLighter

                Rectangle {
                    width: parent.width * root.progress
                    height: parent.height
                    radius: parent.radius
                    color: Data.Settings.warmAccent

                    Behavior on width {
                        NumberAnimation {
                            duration: Data.Settings.animShort
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Data.Settings.spacingSm

                MediaButton {
                    symbol: "⏮"
                    enabled: root.activePlayer?.canGoPrevious ?? false
                    onTriggered: root.activePlayer.previous()
                }
                MediaButton {
                    symbol: root.activePlayer?.isPlaying ? "⏸" : "▶"
                    primary: true
                    enabled: root.activePlayer?.canTogglePlaying ?? false
                    onTriggered: root.activePlayer.togglePlaying()
                }
                MediaButton {
                    symbol: "⏭"
                    enabled: root.activePlayer?.canGoNext ?? false
                    onTriggered: root.activePlayer.next()
                }

                Item { Layout.fillWidth: true }

                MediaButton {
                    symbol: Services.Pipewire.muted ? "×" : "♪"
                    enabled: Services.Pipewire.sinkReady
                    onTriggered: Services.Pipewire.toggleMute()
                }

                Text {
                    text: Services.Pipewire.sinkReady
                        ? Math.round(Services.Pipewire.volume * 100) + "%"
                        : "--%"
                    color: Data.Settings.fgDim
                    font.pixelSize: Data.Settings.fontSm
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    component MediaButton: Rectangle {
        id: button

        property string symbol: ""
        property bool primary: false
        signal triggered()

        Layout.preferredWidth: primary ? 32 : 28
        Layout.preferredHeight: Layout.preferredWidth
        radius: height / 2
        color: primary
            ? Qt.alpha(Data.Settings.warmAccent, 0.18)
            : buttonMouse.containsMouse
                ? Data.Settings.hoverBg
                : Data.Settings.bgLight
        border.width: primary ? 1 : 0
        border.color: Qt.alpha(Data.Settings.warmAccent, 0.35)
        opacity: enabled ? 1 : 0.35

        Text {
            anchors.centerIn: parent
            text: button.symbol
            color: button.primary ? Data.Settings.warmAccent : Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontBase
        }

        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            enabled: button.enabled
            hoverEnabled: true
            cursorShape: button.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: button.triggered()
        }
    }
}
