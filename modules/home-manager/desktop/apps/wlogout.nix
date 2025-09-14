# XXX: Is this supposed to be here?
# TODO: find a better place for this module
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  desktopCfg = config.modules.desktop;

  usingHyprland = desktopCfg.ui.windowManager == "hyprland";
in
{

  options.modules.desktop.apps.wlogout = {
    enable = mkEnableOption "wlogout";
  };

  config = mkIf (desktopCfg.apps.wlogout.enable) {
    programs.wlogout = {
      enable = true;
    };

    wayland.windowManager.hyprland = mkIf usingHyprland {
      settings.bind = [
        "$mainMod, W, exec, wlogout"
      ];
    };
  };
}
