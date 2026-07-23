{ config, ... }:
let
  displayBase = config.flake.modules.nixos.display-base;
in
{
  flake.modules.nixos.display-wayland =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ displayBase ];

      config = {
        modules.system.display.type = "wayland";

        environment = {
          variables = {
            NIXOS_OZONE_WL = "1";
            _JAVA_AWT_WM_NONEREPARENTING = "1";
            GDK_BACKEND = "wayland,x11";
            ANKI_WAYLAND = "1";
            MOZ_ENABLE_WAYLAND = "1";
            XDG_SESSION_TYPE = "wayland";
            SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          };
        };

        environment.systemPackages = with pkgs; [
          wayland
          wayland-utils
          wl-clipboard
        ];

        systemd.services.seatd = {
          enable = true;
          description = "Seat management daemon";
          script = "${lib.getExe pkgs.seatd} -g wheel";
          serviceConfig = {
            Type = "simple";
            Restart = "always";
            RestartSec = "1";
          };
          wantedBy = [ "multi-user.target" ];
        };

        security.pam.loginLimits = [
          {
            domain = "@users";
            item = "rtprio";
            type = "-";
            value = 1;
          }
        ];
      };
    };
}
