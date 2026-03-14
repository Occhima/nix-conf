pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

QtObject {
    readonly property PwNode defaultSink: Pipewire.defaultAudioSink
    readonly property PwNode defaultSource: Pipewire.defaultAudioSource

    readonly property real volume: defaultSink?.audio?.volume ?? 0
    readonly property bool muted: defaultSink?.audio?.muted ?? false

    readonly property string volumeIcon: {
        if (muted || volume === 0) return "audio-volume-muted-symbolic";
        if (volume < 0.33) return "audio-volume-low-symbolic";
        if (volume < 0.66) return "audio-volume-medium-symbolic";
        return "audio-volume-high-symbolic";
    }

    function setVolume(value) {
        if (defaultSink?.audio) {
            defaultSink.audio.volume = Math.max(0, Math.min(1, value));
        }
    }

    function toggleMute() {
        if (defaultSink?.audio) {
            defaultSink.audio.muted = !defaultSink.audio.muted;
        }
    }
}
