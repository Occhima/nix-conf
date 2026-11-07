{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.clipboard =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          services.clipcat = {
            enable = true;
            enableSystemdUnit = true;
          };

          wayland.windowManager.hyprland.settings =
            hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
              [
                {
                  key = "X";
                  dispatcher = "exec";
                  argument = "clipcat-menu --rofi-menu-length 10";
                  lua = hyprlandLib.luaExec "clipcat-menu --rofi-menu-length 10";
                }
              ];
        }
      ];
    };

  flake.modules.homeManager.niri = {
    programs.niri.settings.binds."Mod+X" = {
      hotkey-overlay.title = "Open clipboard history";
      action.spawn = [
        "clipcat-menu"
        "--rofi-menu-length"
        "10"
      ];
    };
  };
}
