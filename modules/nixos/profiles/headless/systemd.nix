{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.occhima) hasProfile;
in
{
  config = mkIf (hasProfile config [ "headless" ]) {
    systemd = {
      enableEmergencyMode = false;

      watchdog = {
        runtimeTime = "20s";
        rebootTime = "30s";
      };

      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
      '';
    };
  };
}
