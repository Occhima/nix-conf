# Guernica Ukishima variation

This is an original, compositor-neutral Quickshell implementation for the
Guernica theme. Its one-pill, morphing-surface interaction is inspired by
[Ukishima](https://github.com/amanhex/ukishima) by Amanhex (inspected at commit
`9dfe085933bd001fb63603a62df9237ccc9ca46a`). Ukishima in turn credits
[Ricelin](https://github.com/Gakuseei/Ricelin) by Gakuseei for its base design.

No Ukishima or Ricelin source is included here: Ukishima did not publish a
license at the inspected commit. The QML in this directory is a clean-room
variation built on this repository's existing Guernica services and widgets.

`ukishima.nix` assembles this variation directly with the neutral primitives
in `../../shared`. It does not import or copy `guernica-base`; the two named
Quickshell configs remain separate dendritic modules and separate source
trees.

The style contract lives in `data/Settings.qml`; the Nix target only replaces
its Base16 placeholders with the active Guernica palette. Integration,
dependencies, and compositor bindings live alongside it in `ukishima.nix`.
