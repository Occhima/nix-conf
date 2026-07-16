# Aggregate: the full graphical desktop — browser, terminal, Hyprland
# with its UI pieces, the Guernica theme and the desktop applications.
{ config, ... }:
{
  config.flake.modules.homeManager.desktop = {
    imports = with config.flake.modules.homeManager; [
      browser-zen-beta
      terminal-kitty
      hyprland
      quickshell-dock
      anyrun
      hyprlock
      themes-guernica
      flatpak
      spotify
      discord
      grimblast
      wlogout
      calibre
    ];
  };
}
