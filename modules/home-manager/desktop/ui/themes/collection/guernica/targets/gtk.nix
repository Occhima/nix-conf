{ config, lib, ... }:

let
  inherit (lib.custom) themeLib;
in
{
  stylix.targets.gtk = themeLib.whenTheme config "guernica" {
    enable = true;
    flatpakSupport.enable = true;
  };
}
