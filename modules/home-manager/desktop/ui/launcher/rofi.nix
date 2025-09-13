{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.modules.desktop.ui;

  usingHyprland = cfg.windowManager == "hyprland";

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

    wayland.windowManager.hyprland = mkIf usingHyprland {

      settings.bind = [
        "$mainMod, SPACE, exec, rofi -show drun"
        "$mainMod, B, exec, rofi-bluetooth"
        "$mainMod, P, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"
      ];
    };

  };
}
