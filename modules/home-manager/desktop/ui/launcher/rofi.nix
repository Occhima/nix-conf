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
  rofiCalcPkg = pkgs.rofi-calc.override { rofi-unwrapped = rofiPkg; };
in
{
  config = mkIf (cfg.launcher == "rofi") {
    programs.rofi = {
      enable = true;
      cycle = true;

      package = if isWayland then pkgs.rofi-wayland else pkgs.rofi;

      extraConfig = {
        modi = "drun,run,filebrowser,window";
        show-icons = true;
        drun-display-format = "{name}";

        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        sidebar-mode = true;
      };

      plugins = [
        rofiFBPkg
        rofiCalcPkg
        pkgs.rofi-power-menu
        pkgs.rofi-bluetooth
      ];
    };
  };
}
