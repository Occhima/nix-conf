{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.modules.services.oom;
  systemdEnabled = config.modules.services.systemd.enable;
in
{
  options.modules.services.oom = {
    enable = mkEnableOption "out of memory prevention";

    earlyoom = {
      enable = mkEnableOption "earlyoom (Early OOM Daemon)";

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

      enableNotifications = mkEnableOption "desktop notifications";
    };
  };

  config = mkIf (cfg.enable && systemdEnabled) {
    services.earlyoom = mkIf cfg.earlyoom.enable {
      enable = true;
      freeMemThreshold = cfg.earlyoom.freeMemThreshold;
      freeSwapThreshold = cfg.earlyoom.freeSwapThreshold;
      enableNotifications = cfg.earlyoom.enableNotifications;
      extraArgs = [
        "-m"
        "20"
        "--avoid 'niceness <= -10'"
        "--interval 60"
      ];
    };

    systemd = {
      oomd = {
        enable = true;
        enableRootSlice = true;
        enableSystemSlice = true;
        enableUserSlices = true;
        extraConfig = {
          "DefaultMemoryPressureDurationSec" = "20s";
        };
      };

      services."nix-daemon".serviceConfig.OOMScoreAdjust = mkDefault 350;

      tmpfiles.settings."10-oomd-root".w = {
        "/sys/module/kernel/parameters/crash_kexec_post_notifiers" = {
          age = "-";
          argument = "Y";
        };
        "/sys/module/printk/parameters/always_kmsg_dump" = {
          age = "-";
          argument = "N";
        };
      };
    };
  };
}
