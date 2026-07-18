# Aggregate: the full graphical desktop — browser, terminal, Hyprland
# with its UI pieces, the Guernica theme and the desktop applications.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.desktop.imports = [
    hm.browser-zen-beta
    hm.terminal-kitty
    hm.hyprland
    hm.quickshell-dock
    hm.anyrun
    hm.hyprlock
    hm.themes-guernica
    hm.flatpak
    hm.spotify
    hm.discord
    hm.grimblast
    hm.wlogout
    hm.calibre
  ];
}
