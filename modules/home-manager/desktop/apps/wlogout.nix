{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.wlogout = { config, ... }: {
    programs.wlogout.enable = true;

    wayland.windowManager.hyprland.settings =
      hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
        [
          {
            key = "W";
            dispatcher = "exec";
            argument = "wlogout";
            lua = hyprlandLib.luaExec "wlogout";
          }
        ];
  };
}
