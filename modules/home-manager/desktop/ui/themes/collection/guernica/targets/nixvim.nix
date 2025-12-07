{ config, lib, ... }:

let
  inherit (lib.custom) themeLib;
in
{
  # Maybe I'll want nvim to manage its colorscheme and opacity itself
  stylix.targets.nixvim.enable = themeLib.whenTheme config "guernica" false;
}
