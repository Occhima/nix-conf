import QtQuick
import QtQuick.Layouts
import Quickshell

import "root:/data" as Data

Item {
    id: root

    readonly property var visibleApplications: [...DesktopEntries.applications.values]
        .filter(entry => entry && !entry.noDisplay)
        .sort((left, right) => left.name.localeCompare(right.name))

    function filteredApplications(): var {
        const needle = search.text.trim().toLowerCase()
        if (!needle.length)
            return visibleApplications

        return visibleApplications.filter(entry => {
            const haystack = [
                entry.name,
                entry.genericName,
                entry.comment,
                ...(entry.keywords ?? []),
                ...(entry.categories ?? [])
            ].join(" ").toLowerCase()
            return haystack.includes(needle)
        })
    }

    function moveSelection(delta): void {
        if (appList.count === 0)
            return
        appList.currentIndex = (appList.currentIndex + delta + appList.count) % appList.count
        appList.positionViewAtIndex(appList.currentIndex, ListView.Contain)
    }

    function launchSelected(): void {
        const entries = filteredApplications()
        const entry = entries[appList.currentIndex]
        if (!entry)
            return
        Data.Runtime.closeAll()
        entry.execute()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        SearchHeader {
            id: search
            Layout.fillWidth: true
            placeholder: "Search apps"
            icon: "search"
            resultCount: appList.count
            totalCount: root.visibleApplications.length
            onTextChanged: appList.currentIndex = 0
            onMoveRequested: delta => root.moveSelection(delta)
            onAccepted: root.launchSelected()
        }

        ListView {
            id: appList

            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ScriptModel { values: root.filteredApplications() }
            currentIndex: count > 0 ? 0 : -1
            spacing: 3
            clip: true

            delegate: Rectangle {
                id: appRow

                required property int index
                required property var modelData

                width: ListView.view.width
                height: 48
                radius: 7
                color: ListView.isCurrentItem
                    ? Qt.alpha(Data.Settings.warmAccent, 0.12)
                    : rowMouse.containsMouse
                        ? Data.Settings.hoverBg
                        : "transparent"
                border.width: ListView.isCurrentItem ? 1 : 0
                border.color: Qt.alpha(Data.Settings.warmAccent, 0.32)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 7
                    anchors.rightMargin: 7
                    spacing: 9

                    Image {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        sourceSize: Qt.size(width, height)
                        source: Quickshell.iconPath(
                            appRow.modelData.icon?.length
                                ? appRow.modelData.icon
                                : "application-x-executable-symbolic"
                        )
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            Layout.fillWidth: true
                            text: appRow.modelData.name
                            color: Data.Settings.fgColor
                            font.pixelSize: Data.Settings.fontSm
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.fillWidth: true
                            text: appRow.modelData.genericName
                                || appRow.modelData.comment
                                || (appRow.modelData.categories ?? [])[0]
                                || "Application"
                            color: Data.Settings.fgDim
                            font.pixelSize: Data.Settings.fontXs
                            elide: Text.ElideRight
                        }
                    }

                    Text {
                        visible: ListView.isCurrentItem
                        text: "↵"
                        color: Data.Settings.warmAccent
                        font.pixelSize: Data.Settings.fontSm
                    }
                }

                MouseArea {
                    id: rowMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: appList.currentIndex = appRow.index
                    onClicked: root.launchSelected()
                }
            }

            Text {
                anchors.centerIn: parent
                visible: appList.count === 0
                text: "No matching applications"
                color: Data.Settings.fgDim
                font.pixelSize: Data.Settings.fontSm
            }
        }
    }
}
