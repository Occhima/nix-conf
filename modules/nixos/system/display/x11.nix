{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.modules.system.display;
in
{
  config = mkIf (cfg.type == "x11") {

    services.xserver.enable = true;
    environment.sessionVariables.QT_QPA_PLATFORMTHEME = "gnome";

    environment.systemPackages = with pkgs; [
      feh
      xdragon
      xclip
      xdotool
      xorg.xwininfo
      qgnomeplatform
      libsForQt5.qtstyleplugin-kvantum
    ];
  };
}
