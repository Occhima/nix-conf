{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;

in
{
  config = mkIf (cfg.locker == "hyprlock") {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          no_fade_in = true;
          no_fade_out = true;
          hide_cursor = false;
          grace = 0;
          disable_loading_bar = true;
        };
      };
    };

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, L, exec, hyprlock"
    ];
  };

}
