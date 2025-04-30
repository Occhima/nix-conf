{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.data.maestral;
in
{
  options.modules.data.maestral = {
    enable = mkEnableOption "Enable maestral for the user";
    service = mkEnableOption "Enable maestral service for the user";
  };

  config = mkIf cfg.enable {

    home.packages = [ pkgs.maestral ];
    systemd.user.services = {
      maestral = mkIf cfg.service {
        Unit = {
          Description = "Maestral (Dropbox)";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStart = "${pkgs.maestral}/bin/maestral start -f";
          ExecStop = "${pkgs.maestral}/bin/maestral stop";
          Restart = "on-failure";
          Nice = 10;
        };
      };
    };
  };
}
