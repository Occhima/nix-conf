{ config, lib, ... }:

let
  inherit (lib.occhima) themeLib;
in
{
  stylix.targets.gtk = themeLib.whenTheme config "guernica" {
    enable = true;
    flatpakSupport.enable = true;
  };

  # gtk.gtk4.theme = config.gtk.theme;
}
