{ config, lib, ... }:

let
  inherit (lib.occhima) themeLib;
in
{
  stylix.targets.qt = themeLib.whenTheme config "guernica" {
    enable = true;
  };
}
