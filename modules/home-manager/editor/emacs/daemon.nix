{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.emacs-daemon =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          services.emacs = {
            enable = true;
            client = {
              enable = true;
              arguments = [ "-c" ];
            };
            defaultEditor = true;
            startWithUserSession = "graphical";
          };

          wayland.windowManager.hyprland.settings =
            hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
              [
                {
                  key = "E";
                  dispatcher = "exec";
                  argument = "emacsclient -c";
                  lua = hyprlandLib.luaExec "emacsclient -c";
                }
              ];
        }
      ];
    };

  flake.modules.homeManager.niri =
    { config, lib, ... }:
    {
      programs.niri.settings.binds."Mod+E" = lib.mkIf (config.services.emacs.enable or false) {
        hotkey-overlay.title = "Open Emacs client";
        action.spawn = [
          "emacsclient"
          "-c"
        ];
      };
    };
}
