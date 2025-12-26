{
  lib,
  config,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr;

  cfg = config.modules.desktop.ui;

in
{

  options.modules.desktop.ui = {
    windowManager = mkOption {
      type = nullOr (enum [
        "hyprland"
        "niri"
        "sway"
        "i3"
        "xmonad"
        "awesome"
      ]);
      default = null;
      description = "The window manager to use";
    };

    notifier = mkOption {
      type = nullOr (enum [
        "mako"
      ]);
      default = null;
      description = "The notifications daemon";
    };

    dock = mkOption {
      type = nullOr (enum [
        "waybar"
        "polybar"
        "caelestia"
        "eww"
      ]);
      default = null;
      description = "The dock/bar to use";
    };

    locker = mkOption {
      type = nullOr (enum [
        "hyprlock"
      ]);
      default = null;
      description = "The dock/bar to use";
    };

    launcher = mkOption {
      type = nullOr (enum [
        "wofi"
        "rofi"
        "dmenu"
        "anyrun"
      ]);
      default = null;
      description = "The application launcher to use";
    };
  };

  config = {
    assertions = [
      {
        assertion = (cfg.dock != "caelestia") || (cfg.windowManager == "hyprland");
        message = "caelestia only configured for Hyprland, select WM: ${cfg.windowManager}";
      }
    ];
  };
}
