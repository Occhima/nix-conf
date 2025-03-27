{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.system.login;
in
{
  config = mkIf (cfg.enable && cfg.manager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = config.modules.system.display.type == "wayland";
      enableHidpi = true;
      package = pkgs.kdePackages.sddm;
      settings.General.InputMethod = "";
    };

  };
}
