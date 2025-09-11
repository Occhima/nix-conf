{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.custom) isWayland;

  usingWayland = isWayland config;
in
{
  config = {
    environment.systemPackages = with pkgs; [ slurp ];

    xdg.portal = {
      enable = true;

      config.common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };

      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      wlr = {
        enable = usingWayland;
        settings = mkIf usingWayland {
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
