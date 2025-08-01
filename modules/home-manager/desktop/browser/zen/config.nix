# NOTE: another feature stolen from the isabelroses/dotfiles repo
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.browser.zen;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.modules.desktop.browser.zen = {
    enable = mkEnableOption "Enable Zen browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
      };
      nativeMessagingHosts = [ pkgs.firefoxpwa ];

    };
  };
}
