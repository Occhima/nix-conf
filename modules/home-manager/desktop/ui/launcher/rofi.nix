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

      programs.niri.settings.binds = {
        "Mod+Space" = {
          repeat = false;
          hotkey-overlay.title = "Open Rofi";
          action.spawn = [
            "rofi"
            "-show"
            "drun"
          ];
        };
        "Mod+B".action.spawn = "rofi-bluetooth";
        "Mod+P".action.spawn = [
          "rofi"
          "-show"
          "power-menu"
          "-modi"
          "power-menu:rofi-power-menu"
        ];
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
