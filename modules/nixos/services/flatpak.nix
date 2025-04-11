{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.custom) hasProfile;

  cfg = config.modules.services.flatpak;
  hasGraphicalProfile = hasProfile config [ "graphical" ];
in
{
  options.modules.services.flatpak = {
    enable = mkEnableOption "Enable the flatpak service";
  };

  config = mkIf cfg.enable {
    warnings = mkIf (!hasGraphicalProfile) [
      "Flatpak is enabled but the 'graphical' profile is not active. Flatpak applications typically need a graphical environment."
    ];
    services.flatpak.enable = true;
  };
}
