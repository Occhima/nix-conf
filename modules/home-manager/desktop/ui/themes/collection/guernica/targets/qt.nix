{ config, lib, ... }:

let
  inherit (lib.custom) themeLib;
in
{
  stylix.targets.qt = themeLib.whenTheme config "guernica" {
    enable = true;
  };
}
