{
  lib,
  config,
  osConfig ? { },
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.attrsets) attrByPath;
  displayType = attrByPath [ "modules" "system" "display" "type" ] false osConfig;
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
