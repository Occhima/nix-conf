{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
in
{
  home.packages = themeLib.whenTheme config "guernica" [
    pkgs.nerd-fonts._0xproto
    pkgs.aporetic
    pkgs.iosevka-comfy.comfy
  ];

  stylix.fonts = themeLib.whenTheme config "guernica" {
    # for programs
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    monospace = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 11;
      desktop = 11;
      terminal = 12;
    };
  };
}
