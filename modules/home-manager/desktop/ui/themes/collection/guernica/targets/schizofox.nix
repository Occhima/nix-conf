{
  config,
  lib,
  ...
}:

let
  inherit (config.lib.stylix) colors;
  inherit (lib.custom) themeLib;

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
}
