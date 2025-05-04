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

    home.packages = [
      pkgs.maestral
    ];

    # TODO ...
    # encrypt with .age?
    # home.file = mkIf agenixRekeyEnabled {
    #   "${config.xdg.configHome}/maestral/maestral.ini" = {
    #     enable = true;
    #     source = osConfig.age.secrets.maestral.path;
    #   };
    # };

    systemd.user.services.maestral = mkIf cfg.service {
      Unit = rec {
        Description = "Maestral - a open-source Dropbox client";
        After = [
          "graphical-session.target"
        ];
        Requires = After;
        ConditionPathExists = [
          "${config.xdg.configHome}/maestral/maestral.ini"
        ];
      };

      Service = {
        Type = "notify";
        ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
        ExecStop = "${pkgs.maestral}/bin/maestral stop";
        Nice = 10;
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
