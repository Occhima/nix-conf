{
  lib,
  ...
}:

let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.modules.display = {
    enable = mkEnableOption "Enable display support";

    type = mkOption {
      type = types.enum [
        "wayland"
        "x11"
        "none"
      ];
      default = "none";
      description = "The display server to use";
    };

    wayland = {
      enable = mkEnableOption "Enable Wayland support";

      compositor = mkOption {
        type = types.enum [
          "hyprland"
          "sway"
          "river"
          "cosmic-comp"
          "none"
        ];
        default = "none";
        description = "The Wayland compositor to use";
      };

      screenSharing = mkEnableOption "Enable screen sharing support";
    };

    portals = {
      enable = mkEnableOption "Enable xdg-desktop-portal support";
    };
  };
}
