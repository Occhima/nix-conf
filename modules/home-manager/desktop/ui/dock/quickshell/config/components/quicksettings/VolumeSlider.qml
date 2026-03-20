import QtQuick
import "root:/data" as Data
import "root:/services" as Services
import "root:/components/shared" as Shared

Shared.SliderControl {
    icon: Services.Pipewire.volumeIcon
    label: "Volume"
    value: Services.Pipewire.sinkReady ? Services.Pipewire.volume : 0
    enabled: Services.Pipewire.sinkReady
    accentColor: Data.Settings.accentColor
    onSliderMoved: newVal => {
        if (Services.Pipewire.sinkReady) Services.Pipewire.setVolume(newVal)
    }
}
