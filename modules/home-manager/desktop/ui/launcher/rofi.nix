{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.modules.desktop.ui;

in
{
  config = mkIf (cfg.launcher == "rofi") {

    home.packages = [
      pkgs.rofi-bluetooth
      pkgs.rofi-power-menu
    ];

    programs.rofi = {
      enable = true;
      cycle = true;
    };

  };
}
