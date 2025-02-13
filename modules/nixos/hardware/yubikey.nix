{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.hardware.yubikey;
in
{
  options.modules.hardware.yubikey = {
    enable = mkEnableOption "YubiKey support";

  };

  config = mkIf cfg.enable {

    services = {
      pcscd.enable = true;
      yubikey-agent.enable = true;

      udev.packages = with pkgs; [
        yubikey-personalization
      ];
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization-gui
      yubico-piv-tool
      pam_u2f
    ];

  };
}
