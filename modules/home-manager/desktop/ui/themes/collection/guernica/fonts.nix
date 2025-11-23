{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  home.packages = lib.mkIf (cfg.enable && cfg.name == "guernica") [
    pkgs.nerd-fonts._0xproto
    pkgs.aporetic
    pkgs.iosevka-comfy.comfy
  ];

  stylix.fonts = lib.mkIf (cfg.enable && cfg.name == "guernica") {
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
