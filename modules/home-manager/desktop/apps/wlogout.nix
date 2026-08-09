{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.wlogout = { config, ... }: {
    programs.wlogout.enable = true;

    programs.niri.settings.binds."Mod+W" = {
      repeat = false;
      hotkey-overlay.title = "Open logout menu";
      action.spawn = "wlogout";
    };

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
