{ ... }:
{
  config.flake.modules.nixos.login-sddm =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      inherit (lib.custom) isWayland;

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
