{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.services.earlyoom;
in
{
  options.modules.services.earlyoom = {
    enable = mkEnableOption "Enable earlyoom (Early OOM Daemon)";

    freeMemThreshold = mkOption {
      type = types.int;
      default = 5;
      description = "Minimum percentage of free memory";
    };

    freeSwapThreshold = mkOption {
      type = types.int;
      default = 10;
      description = "Minimum percentage of free swap";
    };

    enableNotifications = mkEnableOption "Enable desktop notifications";
  };

  config = mkIf cfg.enable {
    services.earlyoom = {
      enable = true;

      # Set memory and swap thresholds
      freeMemThreshold = cfg.freeMemThreshold;
      freeSwapThreshold = cfg.freeSwapThreshold;

      # Use kernel cgroups (useful for systemd)
      # enableCgroup option removed as it doesn't exist in NixOS's earlyoom service currently

      # Enable notifications if configured
      enableNotifications = cfg.enableNotifications;

      # Customize kill preferences
      extraArgs = [
        # Prefer to kill processes that use more memory
        "-m"
        "20"
        # Don't kill processes with a niceness < -10
        "--avoid 'niceness <= -10'"
        # Report memory status every minute (for logs)
        "--interval 60"
      ];
    };
  };
}
