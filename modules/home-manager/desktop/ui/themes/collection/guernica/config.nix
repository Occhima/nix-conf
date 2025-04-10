{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
  wallpaperPath = ./assets/wallpapers/guernica.jpg;
in
{
  stylix = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    image = wallpaperPath;

    opacity = {
      terminal = 0.9;
      desktop = 0.95;
      applications = 1.0;
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
