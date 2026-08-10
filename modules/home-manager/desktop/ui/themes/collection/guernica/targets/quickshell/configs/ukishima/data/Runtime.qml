pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string activePage: ""
    readonly property bool surfaceOpen: activePage.length > 0
    // Networking.qml uses this to decide when detailed link data should be
    // refreshed. Keep the service contract local to this config variation.
    readonly property bool networkPopupVisible: activePage === "network"

    function togglePage(page: string): void {
        activePage = activePage === page ? "" : page
    }

    function closeAll(): void {
        activePage = ""
    }

    IpcHandler {
        target: "guernica-island"

        function dashboard(): void { root.togglePage("launcher") }
        function launcher(): void { root.togglePage("launcher") }
        function clipboard(): void { root.togglePage("clipboard") }
        function bluetooth(): void { root.togglePage("bluetooth") }
        function mixer(): void { root.togglePage("mixer") }
        function system(): void { root.togglePage("system") }
        function calendar(): void { root.togglePage("calendar") }
        function media(): void { root.togglePage("media") }
        function notifications(): void { root.togglePage("notifications") }
        function network(): void { root.togglePage("network") }
        function power(): void { root.togglePage("power") }
        function hide(): void { root.closeAll() }
    }
}
