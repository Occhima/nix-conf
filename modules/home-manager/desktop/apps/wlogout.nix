{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.wlogout =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkMerge [
        {
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
        }
      ];
    };

  # Bindings stay feature-owned, but are only evaluated when hm.niri is selected.
  flake.modules.homeManager.niri =
    { config, lib, ... }:
    {
      programs.niri.settings.binds."Mod+W" = lib.mkIf (config.programs.wlogout.enable or false) {
        repeat = false;
        hotkey-overlay.title = "Open logout menu";
        action.spawn = "wlogout";
      };
    };
}
