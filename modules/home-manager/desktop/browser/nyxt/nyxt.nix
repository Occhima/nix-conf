{
  config,
  lib,
  self,
  pkgs,
  osConfig ? { },
  ...
}:

let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) attrByPath;

  cfg = config.modules.desktop.browser.nyxt;

  appImageEnabledInNixOS = attrByPath [
    "modules"
    "system"
    "appimage"
    "enable"
  ] false osConfig;

  nyxtPackage =
    if appImageEnabledInNixOS then self.packages.${pkgs.system}.nyxt-unstable else pkgs.nyxt;

in
{
  options.modules.desktop.browser.nyxt = {
    enable = mkEnableOption "Enable Nyxt browser";
  };

  config = mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    warnings = mkIf (!appImageEnabledInNixOS) [
      "App image support not enabled in nixos config, falling back to vanilla package install"
    ];
    home = {
      packages = [ nyxtPackage ];
      sessionVariables = {
        WEBKIT_DISABLE_COMPOSITING_MODE = 1;
      };
    };
    xdg.configFile."nyxt".source = ./config;
  };
}
