{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.rofi =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.rofi-bluetooth
        pkgs.rofi-power-menu
      ];

      programs.rofi = {
        enable = true;
        cycle = true;
      };

      wayland.windowManager.hyprland.settings =
        hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
          (
            map
              (
                bind:
                bind
                // {
                  dispatcher = "exec";
                  lua = hyprlandLib.luaExec bind.argument;
                }
              )
              [
                {
                  key = "SPACE";
                  argument = "rofi -show drun";
                }
                {
                  key = "B";
                  argument = "rofi-bluetooth";
                }
                {
                  key = "P";
                  argument = "rofi -show power-menu -modi power-menu:rofi-power-menu";
                }
              ]
          );
    };
}
