{
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr;
  inherit (lib) mkEnableOption;
in
{
  options.modules.system.display = {
    type = mkOption {
      type = nullOr (enum [
        "wayland"
        "x11"
      ]);
      default = null;
      description = "The display server type to use";
    };
    enableHyprlandEssentials = mkEnableOption "Enables hyprland nixosModules";
  };
}
