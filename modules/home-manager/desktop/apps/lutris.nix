# XXX: Is this supposed to be here?
# TODO: find a better place for this module
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  desktopCfg = config.modules.desktop;
in
{

  options.modules.desktop.apps.lutris = {
    enable = mkEnableOption "lutris";
  };

  config = mkIf (desktopCfg.apps.lutris.enable) {
    programs.lutris = {
      enable = true;
    };
  };
}
