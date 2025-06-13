{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.modules) mkDefault;
  cfg = config.modules.hardware.yubikey;
in
{
  options.modules.hardware.yubikey = {
    enable = mkEnableOption "YubiKey support";

  };

  config = mkIf cfg.enable {
    hardware.gpgSmartcards.enable = true;
    services = {
      pcscd.enable = true;
      yubikey-agent.enable = true;

      udev.packages = with pkgs; [
        yubikey-personalization
      ];
    };
    programs = mkDefault {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager
      # yubikey-personalization-gui
      age-plugin-yubikey
      yubico-piv-tool
      pam_u2f
    ];

  };
}
