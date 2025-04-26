{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;
in
{
  config = mkIf (cfg.dock == "waybar") {
    home.packages = [ pkgs.pavucontrol ];
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
  };
}
