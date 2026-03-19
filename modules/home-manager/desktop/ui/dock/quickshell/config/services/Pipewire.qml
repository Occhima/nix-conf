pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

QtObject {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    // Bind the nodes using PwObjectTracker so they become ready
    property var _sinkTracker: PwObjectTracker {
        objects: sink ? [sink] : []
    }
    property var _sourceTracker: PwObjectTracker {
        objects: source ? [source] : []
    }

    readonly property bool sinkReady: (sink !== null) && (sink?.ready === true) && (sink?.audio !== null)
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    readonly property string volumeIcon: {
        if (muted || volume === 0) return "audio-volume-muted-symbolic"
        if (volume < 0.33) return "audio-volume-low-symbolic"
        if (volume < 0.66) return "audio-volume-medium-symbolic"
        return "audio-volume-high-symbolic"
    }

    function setVolume(value) {
        if (sink?.ready && sink?.audio) {
            sink.audio.volume = Math.max(0, Math.min(1, value))
        }
    }

    function toggleMute() {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = !sink.audio.muted
        }
    }
}
