{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkAfter mkIf;
  cfg = config.modules.desktop.ui.themes;
in
{
  wayland.windowManager.hyprland.settings = mkIf (cfg.enable && cfg.name == "guernica") (mkAfter {
    general = {
      gaps_in = 10;
      gaps_out = 30;
      border_size = 1;
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
        noise = 0.10;
        ignore_opacity = true;
      };

      shadow = {
        enabled = true;
        range = 12;
        render_power = 3;
      };
    };

    layerrule = [
      "blur, waybar" # blur Waybar
      "ignorezero, waybar"

      "blur, anyrun" # blur anyrun
      "ignorezero, anyrun"

      "blur, rofi" # blur anyrun "ignorezero, rofi"
      "ignorezero, rofi"

      "blur, logout_dialog"
    ];

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

        "hyprfocusIn, 1, 0.25, focusIn"
        "hyprfocusOut, 1, 0.25, focusOut"
      ];
    };
  });
}
