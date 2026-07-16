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
      # Maybe I'll want nvim to manage its colorscheme and opacity itself
      stylix.targets.nixvim.enable = themeLib.whenTheme config "guernica" false;
    };
}
