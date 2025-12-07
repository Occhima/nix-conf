{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
  wallpaperPath = ./assets/wallpapers/guernica.jpg;
in
{
  stylix = themeLib.whenTheme config "guernica" {
    image = wallpaperPath;

    opacity = {
      terminal = 0.9;
      desktop = 0.95;
      applications = 1.0;
      popups = 0.90;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus";
    };
  };
}
