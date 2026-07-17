{ ... }:
{
  config.occhima.yubikey.nixos =
    { lib, pkgs, ... }:
    let
      inherit (lib.modules) mkDefault;
    in
    {
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
