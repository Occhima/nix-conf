{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.meta) getExe;

  cfg = config.modules.system.display;

in
{

  config = mkMerge [
    (mkIf (cfg.type == "wayland") {
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
        };
      };

      # XXX: Do i need this?
      environment.systemPackages = with pkgs; [
        wayland
        wayland-utils
        wl-clipboard
      ];

      systemd.services.seatd = {
        enable = true;
        description = "Seat management daemon";
        script = "${getExe pkgs.seatd} -g wheel";
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
    })
    (mkIf cfg.enableHyprlandEssentials {
      programs.hyprland = {
        enable = true;
      };
      services.displayManager.sessionPackages = [ pkgs.hyprland ];
      environment.etc."greetd/environments".text = "Hyprland";
    })
  ];

}
