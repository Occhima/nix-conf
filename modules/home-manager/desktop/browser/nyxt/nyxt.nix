{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.modules.desktop.browser.nyxt;

in
{
  options.modules.desktop.browser.nyxt = {
    enable = mkEnableOption "Enable Nyxt browser";
  };

  config = mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home = {
      packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.nyxt-source ];
      sessionVariables = {
        WEBKIT_DISABLE_COMPOSITING_MODE = 1;
      };
    };
    xdg.configFile."nyxt".source = ./config;
  };
}
