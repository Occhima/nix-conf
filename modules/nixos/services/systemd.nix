{ ... }:
{
  flake.modules.nixos.systemd =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) mkEnableOption;
      inherit (lib.modules) mkIf;

      cfg = config.modules.services.systemd;
    in
    {
      options.modules.services.systemd = {
        optimizeServices = mkEnableOption "performance optimizations to services";
      };

      config = {
        services = {
          thermald.enable = true;
          # smartd.enable = true;
          # lvm.enable = false;
        };

        systemd = {
          services = mkIf cfg.optimizeServices {
            "systemd-poweroff".serviceConfig.TimeoutStartSec = 10;
            "systemd-reboot".serviceConfig.TimeoutStartSec = 10;
            "NetworkManager".serviceConfig = {
              LimitNPROC = 100;
              LimitRTPRIO = 50;
            };
            "serial-getty@".environment.TERM = "xterm-256color";
          };

          settings.Manager = {
            DefaultTimeoutStartSec = "15s";
            DefaultTimeoutStopSec = "15s";
            DefaultTimeoutAbortSec = "15s";
            DefaultDeviceTimeoutSec = "15s";
          };

          user = {
            services = {
              graphical-session = {
                description = "Graphical session";
                before = [ "graphical-session-pre.target" ];
                wants = [ "graphical-session-pre.target" ];
                after = [ "systemd-user-sessions.service" ];
                bindsTo = [ "graphical-session.target" ];
              };
            };

            # extraConfig = ''
            #   DefaultTimeoutStartSec = 15s;
            #   DefaultTimeoutStopSec = 15s;
            #   DefaultTimeoutAbortSec = 15s;
            #   DefaultDeviceTimeoutSec = 15s;
            # '';
          };

          coredump.enable = true;
        };

        services.journald = {
          extraConfig = ''
            SystemMaxUse=100M
            SystemMaxFileSize=50M
            RuntimeMaxUse=50M
            Storage=volatile
            ForwardToSyslog=no
            Compress=yes
          '';
        };
      };
    };
}
