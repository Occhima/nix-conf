{ config, ... }:
let
  inherit (config.flake.lib.custom) themeLib;
in
{
  config.flake.modules.homeManager.themes-guernica =
    {
      config,
      ...
    }:
    {
      stylix.targets.gtk = themeLib.whenTheme config "guernica" {
        enable = true;
        flatpakSupport.enable = true;
      };

      # gtk.gtk4.theme = config.gtk.theme;
    };
}
