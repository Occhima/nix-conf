# Guernica Ukishima variation

This is an original, compositor-neutral Quickshell implementation for the
Guernica theme. It deliberately follows the visible layout and interaction of
[Ukishima](https://github.com/amanhex/ukishima) by Amanhex (inspected at commit
`9dfe085933bd001fb63603a62df9237ccc9ca46a`): a centered `160x38` resting pill,
a content-sized `58px` hover bar, and compact surfaces which grow from that
same pill. Ukishima in turn credits
[Ricelin](https://github.com/Gakuseei/Ricelin) by Gakuseei for its base design.

No Ukishima or Ricelin source is included here: Ukishima did not publish a
license at the inspected commit. The QML in this directory is a clean-room
layout adaptation built on this repository's existing Guernica services and
widgets. Its palette, borders, motion accents, and fallbacks remain Guernica.

The hover row keeps Ukishima's visual order: workspaces, clock/date, weather
glance, tray and link state, then inbox, mixer, system, recorder, wallpaper,
clipboard, launcher, appearance, and power affordances. Only integrations
already available in this flake are implemented natively; optional desktop
applications are launched by name and fail harmlessly when absent.

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
alongside it in `ukishima.nix`.
