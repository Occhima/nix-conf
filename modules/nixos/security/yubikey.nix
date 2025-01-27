{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.yubikey;
  homeDir = config.modules.users.user.homeDir;
in
{
  options.modules.yubikey = {
    enable = mkEnableOption "YubiKey support";

    serialNumber = mkOption {
      type = types.str;
      default = "";
      example = "12345678";
      description = "YubiKey serial number for identification";
      apply =
        str:
        if (builtins.match "[0-9]{6,8}" str) != null || str == "" then
          str
        else
          throw "Invalid YubiKey serial number format";
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.pcscd.enable;
        message = "YubiKey module requires pcscd service to be enabled";
      }
      {
        assertion = !cfg.pam.requiredForSudo || cfg.pam.allowSudo;
        message = "Cannot require YubiKey for sudo when sudo support is disabled";
      }
    ];

    services = {
      pcscd.enable = true;
      yubikey-agent.enable = true;
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubico-piv-tool
      pam_u2f
    ];

    services.udev = {
      packages = [ pkgs.yubikey-personalization ];
      extraRules = ''
        # YubiKey state tracking
        SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="1050", \
          RUN+="/run/current-system/sw/bin/touch /run/yubikey-present"
        SUBSYSTEM=="usb", ACTION=="remove", ATTR{idVendor}=="1050", \
          RUN+="/run/current-system/sw/bin/rm -f /run/yubikey-present"

        # Serial number specific rules
        ${optionalString (cfg.serial != "") ''
          ACTION=="add", SUBSYSTEM=="usb", ATTR{serial}=="${cfg.serial}", TAG+="yubikey_auth"
        ''}

        # Lock on removal if enabled
        ${optionalString cfg.security.lockOnRemoval ''
          SUBSYSTEM=="usb", ACTION=="remove", ATTR{idVendor}=="1050", \
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        ''}
      '';
    };

    security.pam = {
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

    environment.sessionVariables = mkIf cfg.debug {
      YKMAN_DEBUG = "1";
    };
  };
}
