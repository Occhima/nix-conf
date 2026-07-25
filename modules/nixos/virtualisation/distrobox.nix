# System distrobox for hosts. The Home Manager `distrobox` module is a
# separate feature.
{
  flake.modules.nixos.distrobox-host =
    {
      lib,
      pkgs,
      ...
    }:
    {
      options.modules.virtualisation.distrobox = {
      };

      config = {
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
    };
}
