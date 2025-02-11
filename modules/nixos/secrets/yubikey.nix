{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.secrets.yubikey;
  homeDir = config.modules.users.user.homeDir;
in
{
  options.modules.secrets.yubikey = {
    enable = mkEnableOption "YubiKey support";
    containsAgeKeys = mkEnableOption "Enable integration with agenix";
    enableSudo = mkEnableOption "Enable sudo U2F password";

  };

  config = mkIf cfg.enable {

    services = {
      pcscd.enable = true;
      yubikey-agent.enable = true;

      udev.packages = with pkgs; [
        yubikey-personalization
      ];
    };

    age.ageBin = mkIf cfg.containsAgeKeys "PATH=$PATH:${
      lib.makeBinPath [ pkgs.age-plugin-yubikey ]
    } ${pkgs.rage}/bin/rage";

    environment.systemPackages = with pkgs; [
      yubikey-manager
      age-plugin-yubikey
      yubikey-personalization
      yubikey-personalization-gui
      yubico-piv-tool
      pam_u2f
    ];

    security.pam = mkIf cfg.enableSudo {
      u2f = {
        enable = true;
        settings = {
          cue = true;
          authFile = "${homeDir}/.config/Yubico/u2f_keys";
        };
      };

      services = {
        sudo = {
          u2fAuth = true;
          requireU2F = cfg.pam.requiredForSudo;
        };
      };
    };

  };
}
