import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "root:/data" as Data
import "root:/components/shared" as Shared

Shared.CardFrame {
    id: root

    readonly property var activePlayer: {
        const players = Mpris.players.values
        for (let i = 0; i < players.length; i++) {
            if (players[i] && players[i].isPlaying)
                return players[i]
        }
        return players.length > 0 ? players[0] : null
    }

    readonly property real playerProgress: {
        const p = activePlayer
        if (!p || !p.length || p.length <= 0)
            return 0
        return Data.Utils.clamp01(p.position / p.length)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Data.Settings.spacingLg
        spacing: Data.Settings.spacingSm

        Rectangle {
            id: coverWrap

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 104
            Layout.preferredHeight: 104
            radius: 28
            clip: true
            color: Qt.alpha(Data.Settings.fgColor, 0.05)

            Image {
                id: coverImg

                anchors.fill: parent
                source: Data.Utils.safeUrl(
                    root.activePlayer ? root.activePlayer.trackArtUrl : undefined
                )
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }

            Text {
                anchors.centerIn: parent
                visible: coverImg.status !== Image.Ready
                text: "\u266a"
                color: Data.Settings.fgDim
                font.pixelSize: 28
            }
        }

        Text {
            Layout.fillWidth: true
            text: Data.Utils.safeString(
                root.activePlayer ? root.activePlayer.trackTitle : undefined,
                "No media"
            )
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontBase
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            Layout.fillWidth: true
            text: Data.Utils.safeString(
                root.activePlayer ? root.activePlayer.trackArtist : undefined,
                "Start a player with MPRIS"
            )
            color: Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontSm
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 6
            radius: 3
            color: Qt.alpha(Data.Settings.fgColor, 0.08)

            Rectangle {
                width: parent.width * root.playerProgress
                height: parent.height
                radius: 3
                color: Data.Settings.accentColor

                Behavior on width {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: root.activePlayer
                ? `${Data.Utils.mediaTimeStr(root.activePlayer.position)} / ${Data.Utils.mediaTimeStr(root.activePlayer.length)}`
                : "--:-- / --:--"
            color: Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontXs
            horizontalAlignment: Text.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Data.Settings.spacingSm

            MediaButton {
                symbol: "\u23ee"
                enabled: root.activePlayer && root.activePlayer.canGoPrevious
                onPressed: function() {
                    root.activePlayer.previous()
                }
            }

            MediaButton {
                symbol: root.activePlayer && root.activePlayer.isPlaying ? "\u23f8" : "\u23f5"
                primary: true
                enabled: root.activePlayer && root.activePlayer.canTogglePlaying
                onPressed: function() {
                    root.activePlayer.togglePlaying()
                }
            }

            MediaButton {
                symbol: "\u23ed"
                enabled: root.activePlayer && root.activePlayer.canGoNext
                onPressed: function() {
                    root.activePlayer.next()
                }
            }
        }
    }

    component MediaButton: Rectangle {
        id: mediaBtn

        property string symbol: ""
        property bool primary: false
        signal pressed()

        implicitWidth: primary ? 38 : 34
        implicitHeight: primary ? 38 : 34
        radius: implicitHeight / 2

        color: !enabled
            ? Qt.alpha(Data.Settings.fgColor, 0.03)
            : primary
                ? Qt.alpha(Data.Settings.accentColor, 0.16)
                : (mediaMouse.containsMouse
                    ? Qt.alpha(Data.Settings.fgColor, 0.07)
                    : Qt.alpha(Data.Settings.fgColor, 0.04))

        border.width: 1
        border.color: primary
            ? Qt.alpha(Data.Settings.accentColor, 0.24)
            : Qt.alpha(Data.Settings.fgColor, 0.06)

        opacity: enabled ? 1.0 : 0.45

        Behavior on color {
            ColorAnimation { duration: Data.Settings.animShort }
        }

        Text {
            anchors.centerIn: parent
            text: mediaBtn.symbol
            color: Data.Settings.fgColor
            font.pixelSize: mediaBtn.primary ? 16 : 14
        }

        MouseArea {
            id: mediaMouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: parent.enabled
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: function(mouse) {
                mouse.accepted = true
                mediaBtn.pressed()
            }
        }
    }
}
