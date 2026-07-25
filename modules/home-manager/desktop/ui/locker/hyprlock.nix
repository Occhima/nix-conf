{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprlock = { config, ... }: {
    programs.hyprlock = {
      enable = true;
      settings.general = {
        no_fade_in = true;
        no_fade_out = true;
        hide_cursor = false;
        grace = 0;
        disable_loading_bar = true;
      };
    };

    wayland.windowManager.hyprland.settings =
      hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
        [
          {
            key = "L";
            dispatcher = "exec";
            argument = "hyprlock";
            lua = hyprlandLib.luaExec "hyprlock";
          }
        ];
  };
}
