{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.modules.desktop.apps.calibre;
in
{

  options.modules.desktop.apps.calibre = {
    enable = mkEnableOption "calibre";
  };

  config = mkIf (cfg.enable) {
    home.packages = [
      pkgs.calibre
    ];

  };
}
