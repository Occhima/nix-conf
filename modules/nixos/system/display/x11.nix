{ occhima, ... }:
{
  config.occhima.display-x11.includes = [ occhima.display-base ];

  config.occhima.display-x11.nixos =
    {
      pkgs,
      config,
      ...
    }:
    {
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
