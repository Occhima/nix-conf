{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.emacs-daemon = { config, ... }: {
    services.emacs = {
      enable = true;
      client = {
        enable = true;
        arguments = [ "-c" ];
      };
      defaultEditor = true;
      startWithUserSession = "graphical";
    };

    programs.niri.settings.binds."Mod+E" = {
      hotkey-overlay.title = "Open Emacs client";
      action.spawn = [
        "emacsclient"
        "-c"
      ];
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
  };
}
