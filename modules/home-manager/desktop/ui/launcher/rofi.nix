{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.custom) isWayland;

  cfg = config.modules.desktop.ui;

  usingHyprland = cfg.windowManager == "hyprland";
  usingWayland = isWayland osConfig;

  rofiPkg = if usingWayland then pkgs.rofi-wayland-unwrapped else pkgs.rofi-unwrapped;
  rofiFBPkg = pkgs.rofi-file-browser.override { rofi = rofiPkg; };
  rofiBluetoothPkg = pkgs.rofi-bluetooth;
  rofiPowerMenuPkg = pkgs.rofi-power-menu;
  rofiCalcPkg = pkgs.rofi-calc.override { rofi-unwrapped = rofiPkg; };
in
{
  config = mkIf (cfg.launcher == "rofi") {

    home.packages = [
      rofiBluetoothPkg
      rofiPowerMenuPkg
    ];
    programs.rofi = {
      enable = true;
      cycle = true;

      package = if usingWayland then pkgs.rofi-wayland else pkgs.rofi;

      plugins = [
        rofiFBPkg
        rofiCalcPkg
      ];
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
