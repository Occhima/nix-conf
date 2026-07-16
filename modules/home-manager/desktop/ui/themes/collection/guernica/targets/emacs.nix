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
      stylix.targets.emacs.enable = themeLib.whenTheme config "guernica" false;
    };
}
