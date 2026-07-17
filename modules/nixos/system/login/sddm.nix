{ config, ... }:
let
  inherit (config.flake.lib.custom) isWayland;
in
{
  config.occhima.login-sddm.nixos =
    {
      config,
      pkgs,
      ...
    }:

    let

      theme = pkgs.elegant-sddm.override {
        themeConfig.General = {
          background = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}";
        };
      };

    in
    {
      config = {
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = isWayland config;
          theme = "Elegant";
        };

        environment.systemPackages = [
          theme
        ];
      };
    };
}
