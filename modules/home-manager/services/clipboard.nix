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
      config = {
        services.clipcat = {
          enable = true;
          enableSystemdUnit = true;
        };

        wayland.windowManager.hyprland.settings = lib.mkIf (config.programs.rofi.enable or false) (
          hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType [
            {
              key = "X";
              dispatcher = "exec";
              argument = "clipcat-menu --rofi-menu-length 10";
              lua = hyprlandLib.luaExec "clipcat-menu --rofi-menu-length 10";
            }
          ]
        );
      };
    };
}
