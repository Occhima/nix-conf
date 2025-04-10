{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf (cfg.enable && cfg.name == "guernica") (
    lib.mkAfter {
      general = {
        gaps_in = 10;
        gaps_out = 30;
        border_size = 1;
        # "col.active_border" = "0xfff1fa8c";
        # "col.inactive_border" = "rgba(00000000)";
      };

      decoration = {
        rounding = 5;
        active_opacity = 0.9;
        inactive_opacity = 0.7;

        blur = {
          enabled = true;
          size = 12;
          passes = 3;
          xray = true;
          noise = 0.05;
          ignore_opacity = true;
        };

        shadow = {
          enabled = true;
          range = 12;
          render_power = 3;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.0"
          "myBezier2, 0.0, 0.1, 0.0, 1.0"
        ];
        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 20, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 0, 2, myBezier2"
        ];
      };
    }
  );
}
