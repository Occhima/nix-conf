{
  lib,
  config,
  osConfig ? { },
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  displayType = osConfig.modules.system.display.type or false;
  isWayland = displayType == "wayland";
  cfg = config.modules.desktop.apps.flameshot;

  flameShotPkg =
    if isWayland then (pkgs.flameshot.override { enableWlrSupport = true; }) else pkgs.flameshot;
in

{

  options.modules.desktop.apps.flameshot = {
    enable = mkEnableOption "flameshot";
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      package = flameShotPkg;
    };
  };
}
