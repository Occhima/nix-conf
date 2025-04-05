{
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr str;
  inherit (lib) mkEnableOption;
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

    dock = mkOption {
      type = nullOr (enum [
        "waybar"
        "polybar"
        "eww"
      ]);
      default = null;
      description = "The dock/bar to use";
    };

    launcher = mkOption {
      type = nullOr (enum [
        "wofi"
        "rofi"
        "dmenu"
      ]);
      default = null;
      description = "The application launcher to use";
    };

    themes = {
      enable = mkEnableOption "Enable UI themes";

      name = mkOption {
        type = str;
        default = "default";
        description = "The UI theme to use";
      };
    };
  };
}
