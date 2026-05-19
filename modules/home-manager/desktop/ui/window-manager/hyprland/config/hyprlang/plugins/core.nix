{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf getExe;
  hyprCfg = config.modules.desktop.ui.windowManagerOpts.hyprland;
in
{
  config = mkIf hyprCfg.enable {
    home.packages = [ pkgs.hyprpicker ];

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, C, exec, ${getExe pkgs.hyprpicker}"
    ];
  };
}
