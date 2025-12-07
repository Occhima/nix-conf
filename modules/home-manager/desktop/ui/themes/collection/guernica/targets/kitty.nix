{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
in
{
  # Disable stylix integration for kitty conditionally
  stylix.targets.kitty.enable = themeLib.whenTheme config "guernica" false;

  # Override font and theme settings conditionally
  programs.kitty = themeLib.whenTheme config "guernica" {
    font.name = config.stylix.fonts.monospace.name;
    themeFile = "Monokai_Soda";
  };
}
