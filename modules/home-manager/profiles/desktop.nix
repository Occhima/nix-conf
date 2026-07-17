# Aggregate: the full graphical desktop — browser, terminal, Hyprland
# with its UI pieces, the Guernica theme and the desktop applications.
{ occhima, ... }:
{
  occhima.desktop.includes = with occhima; [
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
}
