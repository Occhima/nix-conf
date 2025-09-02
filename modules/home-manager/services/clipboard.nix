{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.clipboard;
  uiCfg = config.modules.desktop.ui;
  usingHyprland = uiCfg.windowManager == "hyprland";
  usingRofi = uiCfg.launcher == "rofi";
in
{
  options.modules.services.clipboard = {
    enable = mkEnableOption "CopyQ clipboard manager";
  };

  config = mkIf cfg.enable {
    services.clipcat = {
      enable = true;
      enableSystemdUnit = true;
    };

    wayland.windowManager.hyprland = mkIf (usingHyprland && usingRofi) {
      settings.bind = [
        "$mainMod, K, exec, clipcat-menu --rofi-menu-length 10"
      ];
    };
  };
}
