{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkAfter mkDefault optionalAttrs;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.custom) themeLib;

  isCompact = themeLib.isVariant config "compact";
  stylixColors = config.lib.stylix.colors;

  baseSettings = {
    general = {
      layout = "dwindle";
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

    # NOTE: change to attrset
    layerrule = [
      "match:namespace anyrun, blur on"
      "match:namespace anyrun, ignorealpha on"
      "match:namespace anyrun, blur_popups on"
      "match:namespace anyrun, dim_around on"
      # "match:namespace anyrun, ignorezero on"

      "match:namespace waybar, blur off"
      # "match:namespace waybar, blur_popups on"
      # "match:namespace waybar, dim_around on"
      # "match:namespace waybar, ignorezero on"

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
  };

  compactOverrides = {
    dwindle = {
      pseudotile = true;
      preserve_split = true;
      special_scale_factor = 0.8;
    };

    master = {
      new_status = "master";
      new_on_top = true;
      mfact = 0.5;
    };

    general = {
      gaps_in = 4;
      gaps_out = 6;
      border_size = 2;
      resize_on_border = false;
      layout = "master";
    };

    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      fullscreen_opacity = 1.0;
      dim_inactive = false;
      dim_strength = 0.1;
      dim_special = 0.8;

      shadow = {
        enabled = false;
        range = 6;
        render_power = 1;
        color = mkDefault "rgb(${stylixColors.base0C})";
        color_inactive = mkDefault "rgb(${stylixColors.base0E})";
      };

      blur = {

        enabled = true;
        size = 12;
        passes = 3;
        noise = 0.0200;
        vibrancy = 0.1796;
        ignore_opacity = true;
        new_optimizations = true;
        special = true;
        popups = true;
      };
    };

    layerrule = [
      # "blur, waybar" # blur Waybar
      # "ignorezero, waybar"

      "blur, anyrun" # blur anyrun
      "ignorezero, anyrun"

      "blur, rofi" # blur anyrun "ignorezero, rofi"
      "ignorezero, rofi"

      "blur, logout_dialog"
    ];
    animations = {
      enabled = true;
      bezier = [
        "default, 0, 1, 0, 1"
        "wind, 0.05, 0.69, 0.1, 1"
        "winIn, 0.1, 1.1, 0.1, 1"
        "winOut, 0.3, 1, 0, 1"
        "linear, 1, 1, 1, 1"
        "easeOut, 0.16, 1, 0.3, 1"
      ];

      animation = [
        "windows, 1, 6.9, easeOut, slide"
        "windowsIn, 1, 6.9, easeOut, popin 90%"
        "windowsOut, 1, 6.9, easeOut, popin 80%"
        "windowsMove, 1, 6.9, easeOut, slide"
        "fade, 1, 10, default"
        "workspaces, 1, 10, easeOut, slide"
        "layers, 1, 6.9, easeOut, slide"
      ];
    };
  };

  settings = recursiveUpdate baseSettings (optionalAttrs isCompact compactOverrides);

in
{
  wayland.windowManager.hyprland.settings = themeLib.whenTheme config "guernica" (mkAfter settings);
}
