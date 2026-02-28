{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.browser.brave;
in
{

  options.modules.desktop.browser.brave = {
    enable = mkEnableOption "Enable Brave browser";

  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.brave ];
  };
}
