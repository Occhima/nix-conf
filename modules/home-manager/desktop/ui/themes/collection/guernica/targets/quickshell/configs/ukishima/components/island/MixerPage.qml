import QtQuick

import "root:/data" as Data
import "root:/services" as Services

Item {
    Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: (width - 4 * 72) / 3

        VerticalFader {
            label: "Display"
            glyph: "☀"
            value: Services.Mixer.brightness
            enabled: Services.Mixer.brightnessReady
            accent: Data.Settings.errorColor
            onValueEdited: value => Services.Mixer.setBrightness(value)
        }

        VerticalFader {
            label: "Keyboard"
            glyph: "⌨"
            value: Services.Mixer.keyboardBrightness
            enabled: Services.Mixer.keyboardBrightnessReady
            accent: Data.Settings.purpleColor
            onValueEdited: value => Services.Mixer.setKeyboardBrightness(value)
        }

        VerticalFader {
            label: Services.Mixer.outputMuted ? "Muted" : "Output"
            glyph: Services.Mixer.outputMuted ? "×" : "♪"
            value: Services.Mixer.outputVolume
            enabled: Services.Mixer.sinkReady
            glyphClickable: true
            accent: Services.Mixer.outputMuted
                ? Data.Settings.errorColor
                : Data.Settings.accentColor
            onValueEdited: value => Services.Mixer.setOutputVolume(value)
            onGlyphTriggered: Services.Mixer.toggleOutputMute()
        }

        VerticalFader {
            label: Services.Mixer.inputMuted ? "Muted" : "Mic"
            glyph: Services.Mixer.inputMuted ? "×" : "●"
            value: Services.Mixer.inputVolume
            enabled: Services.Mixer.sourceReady
            glyphClickable: true
            accent: Services.Mixer.inputMuted
                ? Data.Settings.errorColor
                : Data.Settings.successColor
            onValueEdited: value => Services.Mixer.setInputVolume(value)
            onGlyphTriggered: Services.Mixer.toggleInputMute()
        }
    }
}
