{
  lib,
  config,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) int str bool;

  cfg = config.modules.security.auditd;
in
{
  options.modules.security.auditd = {
    enable = mkEnableOption "Enable the audit daemon";

    autoPrune = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable auto-pruning of audit logs";
      };

      size = mkOption {
        type = int;
        default = 524288000; # ~500 megabytes
        description = "The maximum size of the audit log in bytes";
      };

      dates = mkOption {
        type = str;
        default = "daily";
        example = "weekly";
        description = "How often the audit log should be pruned";
      };
    };
  };

  config = mkIf cfg.enable {
    security = {
      auditd.enable = true;

      audit = {
        enable = true;
        backlogLimit = 8192;
        failureMode = "printk";
        rules = [ "-a exit,always -F arch=b64 -S execve" ];
      };
    };

    systemd = mkIf cfg.autoPrune.enable {
      timers."clean-audit-log" = {
        description = "Periodically clean audit log";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.autoPrune.dates;
          Persistent = true;
        };
      };

      services."clean-audit-log" = {
        script = ''
          set -eu
          if [[ $(stat -c "%s" /var/log/audit/audit.log) -gt ${toString cfg.autoPrune.size} ]]; then
            echo "Clearing Audit Log";
            rm -rvf /var/log/audit/audit.log;
            echo "Done!"
          fi
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}
