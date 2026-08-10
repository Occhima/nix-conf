# Guernica Ukishima variation

This is an original, compositor-neutral Quickshell implementation for the
Guernica theme. Its visual layout is inspired by screenshots from
[Ukishima](https://github.com/amanhex/ukishima) by Amanhex. Ukishima in turn
credits [Ricelin](https://github.com/Gakuseei/Ricelin) by Gakuseei for its base
design.

No Ukishima or Ricelin source is included here. Every QML component in this
variation is implemented for this repository, using its existing Guernica
services and shared toolkit. The palette, borders, motion, and source-preview
fallbacks remain Guernica.

The compact dock is always present, so pointer hover never resizes a layer-shell
window. It morphs only when a surface is opened. The implementation includes
native application and clipboard search, Bluetooth discovery and connection
controls, display/keyboard/audio faders, live CPU/memory/network/disk/swap/GPU
metrics, weather and calendar, media, notifications, network, and power.

The surface bindings live beside this variation in `ukishima.nix` and are
rendered for both Hyprland and Niri:

| Binding             | Surface            |
| ------------------- | ------------------ |
| `Super+Space`       | application search |
| `Super+X`           | clipboard search   |
| `Super+Ctrl+B`      | Bluetooth          |
| `Super+Ctrl+M`      | mixer              |
| `Super+Ctrl+S`      | system             |
| `Super+Ctrl+A`      | weather/calendar   |
| `Super+Ctrl+U`      | media              |
| `Super+Ctrl+N`      | notifications      |
| `Super+Ctrl+I`      | network            |
| `Super+Ctrl+P`      | power              |
| `Super+Ctrl+Escape` | close              |

This is a complete source config and can be launched without rebuilding:

```console
quickshell -p modules/home-manager/desktop/ui/themes/collection/guernica/targets/quickshell/configs/ukishima
```

When another shell instance or `mako` already owns desktop notifications,
disable notification ownership in the disposable source preview:

```console
QS_NOTIFICATION_BACKEND=mako quickshell -p modules/home-manager/desktop/ui/themes/collection/guernica/targets/quickshell/configs/ukishima
```

The installed Home Manager service already receives the configured backend;
this override is only for running a second copy by hand.

Repository links expose the neutral primitives from `../../shared` inside
this config root. It never imports or copies `guernica-base`: the variants
retain separate entry points, components, Nix targets, and active-config
names. `ukishima.nix` materializes the links before applying the palette.

The style contract lives in `data/Settings.qml`. Its fallback colors keep the
source preview valid, while the Nix target replaces them with the active
Guernica palette. Integration, dependencies, and compositor bindings live
alongside it in `ukishima.nix`. That target also owns the two `cliphist`
watchers, so clipboard capture works identically under Hyprland and Niri.
