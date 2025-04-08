{
  pkgs,
  ...
}:

let
  wallpaperPath = ./assets/wallpapers/guernica.jpg;
in
{
  stylix = {

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
