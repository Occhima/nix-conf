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
  options.modules.services.steam = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    warnings = mkIf (!hasGraphicalProfile) [
      "Steam is enabled but the 'graphical' profile is not active. Flatpak applications typically need a graphical environment."
    ];
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extest.enable = true;
      platformOptimization.enable = true;
    };
  };
}
