{ config, ... }:
let
  display-base = config.flake.modules.nixos.display-base;
in
{
  config.flake.modules.nixos.display-x11 =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [ display-base ];

      config = {
        modules.system.display.type = "x11";

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
    };
}
