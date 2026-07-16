{ ... }:
{
  config.flake.modules.nixos.display-x11 =
    {
      pkgs,
      config,
      ...
    }:
    {
      config = {

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
