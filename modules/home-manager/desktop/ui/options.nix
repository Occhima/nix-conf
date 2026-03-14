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
        "quickshell"
        "eww"
      ]);
      default = null;
      description = "The dock/bar to use";
    };

    shell = mkOption {
      type = nullOr (enum [
        "quickshell"
      ]);
      default = null;
      description = "The desktop shell toolkit to use";
    };

    locker = mkOption {
      type = nullOr (enum [
        "hyprlock"
      ]);
      default = null;
      description = "The screen locker to use";
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
      {

        assertion = (cfg.dock != "quickshell") || (cfg.windowManager == "hyprland");
        message = "quickshell dock only configured for Hyprland, select WM: ${cfg.windowManager}";
      }
      {
        assertion = !(cfg.shell == "quickshell" && cfg.dock == "caelestia");
        message = "Cannot use quickshell and caelestia together - caelestia is built on quickshell";

      }
    ];
  };
}
