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

        # Niri owns capture, so this feature keeps the same muscle-memory key
        # without trying to launch the Hyprland-only grimblast backend.
        programs.niri.settings.binds = {
          "Mod+S" = {
            repeat = false;
            hotkey-overlay.title = "Capture a region";
            action.screenshot.show-pointer = false;
          };
          "Print" = {
            repeat = false;
            action.screenshot.show-pointer = false;
          };
          "Ctrl+Print" = {
            repeat = false;
            action.screenshot-screen.show-pointer = false;
          };
          "Alt+Print" = {
            repeat = false;
            action.screenshot-window.show-pointer = false;
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
