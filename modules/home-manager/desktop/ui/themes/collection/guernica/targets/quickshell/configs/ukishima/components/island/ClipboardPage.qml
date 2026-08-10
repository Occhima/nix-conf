import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data
import "root:/services" as Services

Item {
    id: root

    function filteredEntries(): var {
        const needle = search.text.trim().toLowerCase()
        if (!needle.length)
            return Services.Clipboard.entries
        return Services.Clipboard.entries.filter(entry => entry.text.toLowerCase().includes(needle))
    }

    function moveSelection(delta): void {
        if (entryList.count === 0)
            return
        entryList.currentIndex = (entryList.currentIndex + delta + entryList.count) % entryList.count
        entryList.positionViewAtIndex(entryList.currentIndex, ListView.Contain)
    }

    function copySelected(): void {
        const entry = filteredEntries()[entryList.currentIndex]
        if (!entry)
            return
        Services.Clipboard.copy(entry)
        Data.Runtime.closeAll()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        SearchHeader {
            id: search
            Layout.fillWidth: true
            placeholder: "Search clipboard"
            icon: "clipboard"
            resultCount: entryList.count
            totalCount: Services.Clipboard.entries.length
            onTextChanged: entryList.currentIndex = 0
            onMoveRequested: delta => root.moveSelection(delta)
            onAccepted: root.copySelected()
        }

        ListView {
            id: entryList

            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ScriptModel {
                objectProp: "id"
                values: root.filteredEntries()
            }
            currentIndex: count > 0 ? 0 : -1
            spacing: 3
            clip: true

            delegate: Rectangle {
                id: entryRow

                required property int index
                required property var modelData

                width: ListView.view.width
                height: 38
                radius: 6
                color: ListView.isCurrentItem
                    ? Qt.alpha(Data.Settings.warmAccent, 0.12)
                    : rowMouse.containsMouse
                        ? Data.Settings.hoverBg
                        : "transparent"

                Text {
                    anchors.left: parent.left
                    anchors.right: arrow.left
                    anchors.leftMargin: 8
                    anchors.rightMargin: 7
                    anchors.verticalCenter: parent.verticalCenter
                    text: entryRow.modelData.text || "(binary clipboard entry)"
                    color: Data.Settings.fgColor
                    font.family: "monospace"
                    font.pixelSize: Data.Settings.fontSm
                    elide: Text.ElideRight
                }

                Text {
                    id: arrow
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    visible: ListView.isCurrentItem
                    text: "→"
                    color: Data.Settings.warmAccent
                    font.pixelSize: Data.Settings.fontSm
                }

                MouseArea {
                    id: rowMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: entryList.currentIndex = entryRow.index
                    onClicked: root.copySelected()
                }
            }

            Text {
                anchors.centerIn: parent
                visible: entryList.count === 0
                text: !Services.Clipboard.probeComplete
                    ? "Checking clipboard tools..."
                    : Services.Clipboard.available
                        ? "Clipboard history is empty"
                        : "cliphist and wl-copy are not in PATH"
                color: Data.Settings.fgDim
                font.pixelSize: Data.Settings.fontSm
            }
        }
    }

    Component.onCompleted: Services.Clipboard.refresh()
}
