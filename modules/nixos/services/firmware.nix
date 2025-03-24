{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.modules.services.firmware;
in
{
  options.modules.services.firmware = {
    enable = mkEnableOption "firmware updater for machine hardware";
  };

  config = mkIf cfg.enable {
    services.fwupd = {
      enable = true;
      daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };
  };
}
