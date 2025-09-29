{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.custom) isWayland;

  usingWayland = isWayland osConfig;

  cfg = config.modules.desktop.apps.flameshot;

  flameShotPkg =
    if usingWayland then (pkgs.flameshot.override { enableWlrSupport = true; }) else pkgs.flameshot;
in

{

  options.modules.desktop.apps.flameshot = {
    enable = mkEnableOption "flameshot";
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      package = flameShotPkg;
      settings = {
        General = {
          useGrimAdapter = usingWayland;
          disabledGrimWarning = true;
        };
      };
    };

  };
}
