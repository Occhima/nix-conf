{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
in
{
  stylix.targets.kitty.enable = themeLib.whenTheme config "guernica" false;

  programs.ghostty = themeLib.whenTheme config "guernica" {
    settings = {
      font-family = config.stylix.fonts.monospace.name;
      cursor-style-blink = true;
      cursor-style = "block";
      font-feature = "+liga";
    };
  };
}
