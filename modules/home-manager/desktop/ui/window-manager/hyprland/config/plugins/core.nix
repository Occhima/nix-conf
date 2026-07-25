{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.hyprpicker ];
      wayland.windowManager.hyprland.settings =
        hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
          [
            {
              key = "C";
              dispatcher = "exec";
              argument = lib.getExe pkgs.hyprpicker;
              lua = hyprlandLib.luaExec (lib.getExe pkgs.hyprpicker);
            }
          ];
    };
}
