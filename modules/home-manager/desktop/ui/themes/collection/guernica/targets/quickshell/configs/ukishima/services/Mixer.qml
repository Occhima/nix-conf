pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool sinkReady: sink !== null && sink?.ready === true && sink?.audio !== null
    readonly property bool sourceReady: source !== null && source?.ready === true && source?.audio !== null
    readonly property real outputVolume: sink?.audio?.volume ?? 0
    readonly property real inputVolume: source?.audio?.volume ?? 0
    readonly property bool outputMuted: sink?.audio?.muted ?? false
    readonly property bool inputMuted: source?.audio?.muted ?? false

    property real brightness: 0
    property real keyboardBrightness: 0
    property real pendingBrightness: 0
    property real pendingKeyboardBrightness: 0
    property bool brightnessReady: false
    property bool keyboardBrightnessReady: false

    PwObjectTracker {
        objects: [root.sink, root.source].filter(node => node !== null)
    }

    function clamp(value): real {
        return Math.max(0, Math.min(1, value))
    }

    function parseBrightness(output, keyboard): void {
        const line = output.trim().split("\n")[0] ?? ""
        const fields = line.split(",")
        if (fields.length < 4)
            return

        const parsed = parseFloat(fields[3].replace("%", ""))
        if (isNaN(parsed))
            return

        if (keyboard) {
            keyboardBrightness = clamp(parsed / 100)
            keyboardBrightnessReady = true
        } else {
            brightness = clamp(parsed / 100)
            brightnessReady = true
        }
    }

    function setBrightness(value): void {
        pendingBrightness = clamp(value)
        brightness = pendingBrightness
        brightnessDebounce.restart()
    }

    function setKeyboardBrightness(value): void {
        pendingKeyboardBrightness = clamp(value)
        keyboardBrightness = pendingKeyboardBrightness
        keyboardDebounce.restart()
    }

    function setOutputVolume(value): void {
        if (sinkReady) {
            sink.audio.muted = false
            sink.audio.volume = clamp(value)
        }
    }

    function setInputVolume(value): void {
        if (sourceReady) {
            source.audio.muted = false
            source.audio.volume = clamp(value)
        }
    }

    function toggleOutputMute(): void {
        if (sinkReady)
            sink.audio.muted = !sink.audio.muted
    }

    function toggleInputMute(): void {
        if (sourceReady)
            source.audio.muted = !source.audio.muted
    }

    Process {
        id: brightnessQuery
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: root.parseBrightness(text, false)
        }
    }

    Process {
        id: keyboardQuery
        command: ["brightnessctl", "-m", "-d", "*::kbd_backlight"]
        stdout: StdioCollector {
            onStreamFinished: root.parseBrightness(text, true)
        }
    }

    Process {
        id: brightnessSet
        onExited: brightnessQuery.running = true
    }

    Process {
        id: keyboardSet
        onExited: keyboardQuery.running = true
    }

    Timer {
        id: brightnessDebounce
        interval: 90
        onTriggered: {
            if (brightnessSet.running) {
                restart()
                return
            }
            brightnessSet.command = [
                "brightnessctl",
                "set",
                Math.round(root.pendingBrightness * 100) + "%"
            ]
            brightnessSet.running = true
        }
    }

    Timer {
        id: keyboardDebounce
        interval: 90
        onTriggered: {
            if (keyboardSet.running) {
                restart()
                return
            }
            keyboardSet.command = [
                "brightnessctl",
                "-d",
                "*::kbd_backlight",
                "set",
                Math.round(root.pendingKeyboardBrightness * 100) + "%"
            ]
            keyboardSet.running = true
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!brightnessQuery.running)
                brightnessQuery.running = true
            if (!keyboardQuery.running)
                keyboardQuery.running = true
        }
    }
}
