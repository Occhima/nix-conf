{ ... }:
{
  config.flake.modules.homeManager.themes-guernica =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib.custom) themeLib;
    in
    {
      stylix.targets.waybar = themeLib.whenTheme config "guernica" {
        enable = false;
        addCss = false;
        enableCenterBackColors = false;
        enableLeftBackColors = false;
        enableRightBackColors = false;
      };
    };
}
