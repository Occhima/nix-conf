{ config, lib, ... }:

let
  inherit (lib.occhima) themeLib;
in
{
  stylix.targets.emacs.enable = themeLib.whenTheme config "guernica" false;
}
