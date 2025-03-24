{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;

  cfg = config.modules.system.display;
  isWayland = cfg.type == "wayland";
in
{
  config = {
    xdg.portal = {
      enable = true;

      config.common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };

      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      wlr = {
        enable = mkIf isWayland true;
        settings = mkIf isWayland {
          screencast = {
            max_fps = 60;
            chooser_type = "simple";
            chooser_cmd = "${getExe pkgs.slurp} -f %o -or";
          };
        };
      };
    };
  };
}
