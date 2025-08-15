{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.custom) isWayland;
  cfg = config.modules.system.login;

  theme = pkgs.elegant-sddm.override {
    themeConfig.General = {
      background = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}";
    };
  };

in
{
  config = mkIf (cfg.enable && cfg.manager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = isWayland config;
      theme = "Elegant";
    };

    environment.systemPackages = [
      theme
    ];
  };
}
