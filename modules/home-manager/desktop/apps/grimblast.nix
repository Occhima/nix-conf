{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.grimblast =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = [ pkgs.grimblast ];

        programs.satty = {
          enable = true;
          settings = {
            general = {
              early-exit = true;
              copy-command = "wl-copy";
              save-after-copy = true;
              output-filename = "${config.xdg.userDirs.extraConfig.SCREENSHOTS}/satty-{ts}.png";
              annotation-size-factor = 2;
            };
          };
        };

        wayland.windowManager.hyprland.settings =
          hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
            [
              {
                key = "S";
                dispatcher = "exec";
                argument = "grimblast save area - | satty --filename -";
                lua = hyprlandLib.luaExec "grimblast save area - | satty --filename -";
              }
            ];
      };
    };
}
