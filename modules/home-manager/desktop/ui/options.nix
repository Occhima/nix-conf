{
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr;

in
{

  options.modules.desktop.ui = {
    windowManager = mkOption {
      type = nullOr (enum [
        "hyprland"
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
        "eww"
      ]);
      default = null;
      description = "The dock/bar to use";
    };

    osd = mkOption {
      type = nullOr (enum [
        "avizo"
      ]);
      default = null;
      description = "The OSD to use";
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
}
