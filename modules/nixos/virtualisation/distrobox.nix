# System distrobox for hosts. The Home Manager `distrobox` aspect is a
# separate feature.
{ ... }:
{
  config.occhima.distrobox-host.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib) meta;
    in
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
