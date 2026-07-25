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
