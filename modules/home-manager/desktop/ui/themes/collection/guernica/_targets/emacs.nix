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
      stylix.targets.emacs.enable = themeLib.whenTheme config "guernica" false;
    };
}
