{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.custom) isWayland;

  cfg = config.modules.services.flatpak;

in
{
  options.modules.services.steam = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extest.enable = true;
      package = mkIf (isWayland config) (
        pkgs.steam.override {
          extraEnv = {
            PROTON_ENABLE_HDR = 1;
            PROTON_ENABLE_WAYLAND = 1;
            PROTON_USE_NTSYNC = 1;
            WAYLANDDRV_PRIMARY_MONITOR = config.modules.hardware.monitors.primaryMonitorName;
          };
        }
      );

    };
  };
}
