{
  config,
  lib,
  pkgs,
  osConfig ? { },
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.attrsets) attrByPath;
  cfg = config.modules.desktop.ui;
  displayType = attrByPath [ "modules" "system" "display" "type" ] "" osConfig;
  isWayland = displayType == "wayland";
  rofiPkg = if isWayland then pkgs.rofi-wayland-unwrapped else pkgs.rofi-unwrapped;
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

      package = if isWayland then pkgs.rofi-wayland else pkgs.rofi;

      plugins = [
        rofiFBPkg
        rofiCalcPkg

      ];
    };
  };
}
