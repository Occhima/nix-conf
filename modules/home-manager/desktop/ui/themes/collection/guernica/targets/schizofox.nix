{ config, ... }:
let
  inherit (config.flake.lib.custom) themeLib;
in
{
  config.flake.modules.homeManager.themes-guernica =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.lib.stylix) colors;
    in
    {
      programs.schizofox = themeLib.whenTheme config "guernica" {
        extensions.simplefox.enable = true;
        theme = {
          colors = {
            background-darker = colors.base01;
            background = colors.base00;
            foreground = colors.base05;
          };
          font = config.stylix.fonts.monospace.name;
        };
      };
    };
}
