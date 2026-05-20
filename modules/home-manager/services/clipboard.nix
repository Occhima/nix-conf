{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.clipboard;
  uiCfg = config.modules.desktop.ui;
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

    wayland.windowManager.hyprland.settings.bind = mkIf (uiCfg.launcher == "rofi") [
      "$mainMod, X, exec, clipcat-menu --rofi-menu-length 10"
    ];
  };
}
