{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.services.systemd;
in
{
  options.modules.services.systemd = {
    enable = mkEnableOption "Enable systemd optimizations";

    oomd = mkEnableOption "Enable systemd-oomd to prevent OOM conditions";

    networkd = mkEnableOption "Use systemd-networkd instead of NetworkManager";

    optimizeServices = mkEnableOption "Apply performance optimizations to services";
  };

  config = mkIf cfg.enable {
    # Optimize systemd runtime
    systemd = {
      # Tune systemd's out-of-memory killer
      oomd = mkIf cfg.oomd {
        enable = true;
        enableSystemSlice = true;
        enableUserSlices = true;
      };

      # Use networkd instead of NetworkManager if enabled
      network = mkIf cfg.networkd {
        enable = true;
        wait-online.enable = false;
      };

      # Enable resolved for DNS resolution through services module
      # Using the separate services.resolved module

      # Service optimizations
      services = mkIf cfg.optimizeServices {
        # Adjust timeouts for shutdown
        "systemd-poweroff".serviceConfig.TimeoutStartSec = 10;
        "systemd-reboot".serviceConfig.TimeoutStartSec = 10;

        # Speed up NetworkManager startup
        "NetworkManager".serviceConfig = {
          LimitNPROC = 100;
          LimitRTPRIO = 50;
        };
      };

      # Global performance settings
      extraConfig = ''
        # Reduce default timeout for stopping services
        DefaultTimeoutStopSec=15s

        # Increase default timeout for starting services
        DefaultTimeoutStartSec=30s

        # Always use tmpfs for /tmp
        JoinMountNamespace=yes
      '';

      # Optimize user services
      user = {
        services.graphical-session = {
          description = "Graphical session";
          before = [ "graphical-session-pre.target" ];
          wants = [ "graphical-session-pre.target" ];
          after = [ "systemd-user-sessions.service" ];
          bindsTo = [ "graphical-session.target" ];
        };
      };
    };

    # Enable coredumps for better debugging
    systemd.coredump.enable = true;

    # Setup journald
    services.journald = {
      extraConfig = ''
        # Limit journal size
        SystemMaxUse=500M
        SystemMaxFileSize=50M

        # Keep logs in volatile memory
        Storage=volatile

        # Forward to syslog
        ForwardToSyslog=no

        # Compress larger logs
        Compress=yes
      '';
    };
  };
}
