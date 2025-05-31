{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (self.lib.custom) isWayland;
  cfg = config.modules.system.login;
in
{
  config = mkIf (cfg.enable && cfg.manager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = isWayland config;
      enableHidpi = true;
      package = pkgs.kdePackages.sddm;
      settings.General.InputMethod = "";
    };

  };
}
