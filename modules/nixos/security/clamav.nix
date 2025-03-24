{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.strings) escapeShellArgs;
  inherit (lib.types)
    int
    str
    bool
    oneOf
    listOf
    attrsOf
    ;

  cfg = config.modules.security.clamav;
in
{
  options.modules.security.clamav = {
    enable = mkEnableOption "ClamAV daemon and scanner";

    daemon = {
      settings = mkOption {
        type = attrsOf (oneOf [
          bool
          int
          str
          (listOf str)
        ]);
        default = {
          LogFile = "/var/log/clamd.log";
          LogTime = true;
          DetectPUA = true;
          VirusEvent = escapeShellArgs [
            "${pkgs.libnotify}/bin/notify-send"
            "--"
            "ClamAV Virus Scan"
            "Found virus: %v"
          ];
        };
        description = "ClamAV configuration";
      };
    };

    updater = {
      frequency = mkOption {
        type = int;
        default = 12;
        description = "Number of database checks per day";
      };

      interval = mkOption {
        type = str;
        default = "hourly";
        description = "How often freshclam is invoked";
      };

      settings = mkOption {
        type = attrsOf (oneOf [
          bool
          int
          str
          (listOf str)
        ]);
        default = { };
        description = "Freshclam configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    services.clamav = {
      daemon = {
        enable = true;
        settings = cfg.daemon.settings;
      };
      updater = {
        enable = true;
        frequency = cfg.updater.frequency;
        interval = cfg.updater.interval;
        settings = cfg.updater.settings;
      };
    };

    systemd = {
      tmpfiles.settings."10-clamav"."/var/lib/clamav".D = {
        mode = "755";
        user = "clamav";
        group = "clamav";
      };

      services = {
        clamav-daemon = {
          serviceConfig = {
            PrivateTmp = mkForce "no";
            PrivateNetwork = mkForce "no";
            Restart = "always";
          };

          unitConfig = {
            ConditionPathExistsGlob = [
              "/var/lib/clamav/main.{c[vl]d,inc}"
              "/var/lib/clamav/daily.{c[vl]d,inc}"
            ];
          };
        };

        clamav-init-database = {
          wantedBy = [ "clamav-daemon.service" ];
          before = [ "clamav-daemon.service" ];
          serviceConfig.ExecStart = "systemctl start clamav-freshclam";
          unitConfig = {
            ConditionPathExistsGlob = [
              "!/var/lib/clamav/main.{c[vl]d,inc}"
              "!/var/lib/clamav/daily.{c[vl]d,inc}"
            ];
          };
        };

        clamav-freshclam = {
          wants = [ "clamav-daemon.service" ];
          serviceConfig = {
            ExecStart = "${pkgs.coreutils}/bin/echo -en Updating ClamAV database";
            SuccessExitStatus = mkForce [
              11
              40
              50
              51
              52
              53
              54
              55
              56
              57
              58
              59
              60
              61
              62
            ];
          };
        };
      };

      timers.clamav-freshclam.timerConfig = {
        RandomizedDelaySec = "60m";
        FixedRandomDelay = true;
        Persistent = true;
      };
    };
  };
}
