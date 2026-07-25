{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib themeLib;
in
{
  flake.modules.homeManager.themes-guernica =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) mkAfter mkDefault;
      inherit (lib.attrsets) recursiveUpdate;

      configType = config.wayland.windowManager.hyprland.configType;
      isCompact = themeLib.isVariant config "compact";
      stylixColors = config.lib.stylix.colors;

      baseConfig = {
        general = {
          gaps_in = 8;
          gaps_out = 20;
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

        animations.enabled = true;
      };

      compactConfig = {
        general = {
          gaps_in = 4;
          gaps_out = 6;
          border_size = 2;
          resize_on_border = false;
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
            noise = 0.02;
            vibrancy = 0.1796;
            ignore_opacity = true;
            new_optimizations = true;
            special = true;
            popups = true;
          };
        };
      };

      baseCurves = [
        {
          name = "myBezier";
          points = [
            0.05
            0.9
            0.1
            1.0
          ];
        }
        {
          name = "myBezier2";
          points = [
            0.0
            0.1
            0.0
            1.0
          ];
        }
      ];

      compactCurves = [
        {
          name = "default";
          points = [
            0
            1
            0
            1
          ];
        }
        {
          name = "wind";
          points = [
            0.05
            0.69
            0.1
            1
          ];
        }
        {
          name = "winIn";
          points = [
            0.1
            1.1
            0.1
            1
          ];
        }
        {
          name = "winOut";
          points = [
            0.3
            1
            0
            1
          ];
        }
        {
          name = "linear";
          points = [
            1
            1
            1
            1
          ];
        }
        {
          name = "easeOut";
          points = [
            0.16
            1
            0.3
            1
          ];
        }
      ];

      baseAnimations = [
        {
          leaf = "windows";
          enabled = true;
          speed = 3;
          bezier = "myBezier";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 3;
          bezier = "default";
          style = "popin 80%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 20;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 8;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 7;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = false;
          speed = 2;
          bezier = "myBezier2";
        }
      ];

      compactAnimations = [
        {
          leaf = "windows";
          enabled = true;
          speed = 6.9;
          bezier = "easeOut";
          style = "slide";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 6.9;
          bezier = "easeOut";
          style = "popin 90%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 6.9;
          bezier = "easeOut";
          style = "popin 80%";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 6.9;
          bezier = "easeOut";
          style = "slide";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 10;
          bezier = "easeOut";
          style = "slide";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 6.9;
          bezier = "easeOut";
          style = "slide";
        }
      ];

      baseLayerRules = [
        {
          name = "anyrun";
          namespace = "anyrun";
          blur = false;
          blur_popups = true;
          dim_around = true;
        }
        {
          name = "waybar";
          namespace = "waybar";
          blur = false;
        }
        {
          name = "quickshell";
          namespace = "quickshell";
          blur = true;
          blur_popups = true;
          dim_around = true;
        }
      ];

      compactLayerRules =
        map
          (namespace: {
            name = namespace;
            inherit namespace;
            blur = true;
            ignore_alpha = 0.0;
          })
          [
            "anyrun"
            "rofi"
            "quickshell"
            "logout_dialog"
          ];

      themeConfig = recursiveUpdate baseConfig (if isCompact then compactConfig else { });
      curves = if isCompact then compactCurves else baseCurves;
      animations = if isCompact then compactAnimations else baseAnimations;
      layerRules = if isCompact then compactLayerRules else baseLayerRules;

      settings = recursiveUpdate (hyprlandLib.mkConfig configType themeConfig) (
        recursiveUpdate (hyprlandLib.mkAnimations configType {
          inherit curves animations;
        }) (hyprlandLib.mkLayerRules configType layerRules)
      );
    in
    {
      wayland.windowManager.hyprland.settings = mkAfter settings;
    };
}
