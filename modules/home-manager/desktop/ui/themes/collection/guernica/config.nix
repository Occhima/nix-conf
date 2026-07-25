{ config, ... }:
let
  guernicaAssets = config.flake.lib.guernica.assets;
in
{
  flake.modules.homeManager.themes-guernica =
    { pkgs, ... }:
    let
      wallpaperPath = guernicaAssets.wallpaper;
    in
    {
      # stylix.cursor sets home.pointerCursor; HM now wants an explicit enable.
      home.pointerCursor.enable = true;

      stylix = {
        image = wallpaperPath;

        opacity = {
          terminal = 0.8;
          desktop = 0.8;
          applications = 1.0;
          popups = 0.90;
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };

        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus";
        };
      };
    };
}
