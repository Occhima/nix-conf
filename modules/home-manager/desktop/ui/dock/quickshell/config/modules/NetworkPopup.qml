import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/data" as Data
import "root:/services" as Services

Scope {
    Variants {
        model: Quickshell.screens

        WlrLayershell {
            property var modelData

            screen: modelData
            layer: WlrLayer.Overlay
            namespace: "quickshell-network-popup"
            exclusiveZone: 0
            visible: Data.Runtime.networkPopupVisible

            anchors {
                top: true
                right: true
            }

            implicitWidth: 420
            implicitHeight: 220
            color: "transparent"

            Rectangle {
                id: panel

                anchors {
                    top: parent.top
                    topMargin: 4
                    right: parent.right
                    rightMargin: Data.Settings.barSideMargin
                }

                width: 320
                height: content.implicitHeight + 20
                radius: 14
                color: Data.Settings.bgColorTranslucent
                border.width: 1
                border.color: Data.Settings.borderNormal

                opacity: Data.Runtime.networkPopupVisible ? 1.0 : 0.0
                scale: Data.Runtime.networkPopupVisible ? 1.0 : Data.Settings.popupScaleHidden
                transformOrigin: Item.TopRight

                Behavior on opacity { NumberAnimation { duration: Data.Settings.animShort } }
                Behavior on scale { NumberAnimation { duration: Data.Settings.animMedium; easing.type: Easing.OutCubic } }

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    anchors.margins: Data.Settings.spacingMd
                    spacing: Data.Settings.spacingXs

                    Text {
                        Layout.fillWidth: true
                        text: Services.Networking.connected
                              ? "Network: " + Services.Networking.statusText
                              : "Network: Offline"
                        color: Data.Settings.fgColor
                        font.pixelSize: Data.Settings.fontBase
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                    }

                    InfoRow { label: "Interface"; value: Services.Networking.activeInterface || "--" }
                    InfoRow { label: "IPv4"; value: Services.Networking.ipv4Address || "--" }
                    InfoRow { label: "Gateway"; value: Services.Networking.gateway || "--" }
                    InfoRow { label: "Down"; value: Services.Networking.downloadKbps.toFixed(1) + " KB/s" }
                    InfoRow { label: "Up"; value: Services.Networking.uploadKbps.toFixed(1) + " KB/s" }
                }
            }
        }
    }

    component InfoRow: RowLayout {
        property string label
        property string value

        Layout.fillWidth: true
        spacing: Data.Settings.spacingMd

        Text {
            text: label + ":"
            color: Data.Settings.fgDim
            font.pixelSize: Data.Settings.fontSm
            Layout.preferredWidth: 74
        }

        Text {
            Layout.fillWidth: true
            text: value
            color: Data.Settings.fgColor
            font.pixelSize: Data.Settings.fontSm
            elide: Text.ElideRight
        }
    }
}
