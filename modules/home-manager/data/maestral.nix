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
      pkgs.maestral-gui
    ];

    # TODO ...
    # encrypt with .age?
    # home.file = {
    #   "${config.xdg.configHome}/maestral/maestral.ini" = {
    #     enable = true;
    #     source =
    #       let
    #         format = pkgs.formats.ini { };
    #         configFile = format.generate "maestral.ini" {
    #           auth = {
    #             keyring = "automatic";
    #           };
    #           app = {
    #             notification_level = 15;
    #             log_level = 20;
    #             update_notification_interval = 604800;
    #             bandwidth_limit_up = 0.0;
    #             bandwidth_limit_down = 0.0;
    #             max_parallel_uploads = 6;
    #             max_parallel_downloads = 6;
    #           };
    #           sync = {
    #             path = "${config.home.homeDirectory}/Dropbox";
    #             reindex_interval = 604800;
    #             maximum_cpu_percent = 10.0;
    #             keep_history = 604800;
    #             upload = "True";
    #             download = "True";
    #           };
    #         };
    #       in
    #       configFile;
    #   };
    # };

    systemd.user.services.maestral = mkIf cfg.service {
      Unit = rec {
        Description = "Maestral - a open-source Dropbox client";
        After = [
          "graphical-session.target"
        ];
        Requires = After;
        # ConditionPathExists = [
        #   "${config.xdg.configHome}/maestral/maestral.ini"
        # ];
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
