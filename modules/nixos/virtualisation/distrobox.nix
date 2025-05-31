{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf meta;
  cfg = config.modules.virtualisation.distrobox;
in
{
  options.modules.virtualisation.distrobox = {
    enable = mkEnableOption "Distrobox for running distributions in containers";
  };

  config = mkIf cfg.enable {
    # Define assertion to ensure requirements are met
    assertions = [
      {
        assertion =
          config.modules.virtualisation.docker.enable || config.modules.virtualisation.podman.enable;
        message = "Distrobox requires either Docker or Podman to be enabled. Enable modules.virtualisation.docker or modules.virtualisation.podman.";
      }
    ];

    environment.systemPackages = with pkgs; [
      distrobox
    ];

    systemd.user = {
      timers."distrobox-update" = {
        enable = true;
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1h";
          OnUnitActiveSec = "1d";
          Unit = "distrobox-update.service";
        };
      };

      services."distrobox-update" = {
        enable = true;
        script = ''
          ${lib.meta.getExe' pkgs.distrobox "distrobox"} upgrade --all
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
  };
}
