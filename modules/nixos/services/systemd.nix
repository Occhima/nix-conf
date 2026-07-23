{
  flake.modules.nixos.systemd =
    { ... }:
    {
      services = {
        thermald.enable = true;
        # smartd.enable = true;
        # lvm.enable = false;
      };

      systemd = {
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
}
