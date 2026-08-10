# Guernica base variation

This is a complete source config for the original Guernica Quickshell layout:

```console
quickshell -p modules/home-manager/desktop/ui/themes/collection/guernica/targets/quickshell/configs/base
```

Repository links expose the neutral primitives from `../../shared` inside
this config root. `base.nix` materializes those links and applies the active
palette; it never imports or copies the Ukishima variation.

## Credits

- Configs used as inspiration to build this quickshell config:
  https://github.com/ShiNoNeko47/caelestia-shell
  https://github.com/tripathiji1312/quickshell
  https://github.com/isabelroses/dotfiles
