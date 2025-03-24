{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.types) enum;
  inherit (lib.options) mkOption mkEnableOption;

  cfg = config.modules.security.selinux;
in
{
  options.modules.security.selinux = {
    enable = mkEnableOption "SELinux support with kernel patches";

    state = mkOption {
      type = enum [
        "enforcing"
        "permissive"
        "disabled"
      ];
      default = "enforcing";
      description = "SELinux state to boot with";
    };

    type = mkOption {
      type = enum [
        "targeted"
        "minimum"
        "mls"
      ];
      default = "targeted";
      description = "SELinux policy type to boot with";
    };
  };

  config = mkIf cfg.enable {
    systemd.package = pkgs.systemd.override { withSelinux = true; };

    security.apparmor.enable = mkForce false;

    boot = {
      kernelParams = [
        "security=selinux"
        "selinux=1"
      ];

      kernelPatches = [
        {
          name = "selinux-config";
          patch = null;
          extraConfig = ''
            SECURITY_SELINUX y
            SECURITY_SELINUX_BOOTPARAM n
            SECURITY_SELINUX_DISABLE n
            SECURITY_SELINUX_DEVELOP y
            SECURITY_SELINUX_AVC_STATS y
            SECURITY_SELINUX_CHECKREQPROT_VALUE 0
            DEFAULT_SECURITY_SELINUX n
          '';
        }
      ];
    };

    environment = {
      systemPackages = [ pkgs.policycoreutils ];

      etc."selinux/config".text = ''
        # This file controls the state of SELinux on the system.
        # SELINUX= can take one of these three values:
        #     enforcing - SELinux security policy is enforced.
        #     permissive - SELinux prints warnings instead of enforcing.
        #     disabled - No SELinux policy is loaded.
        SELINUX=${cfg.state}
        # SELINUXTYPE= can take one of three two values:
        #     targeted - Targeted processes are protected,
        #     minimum - Modification of targeted policy. Only selected processes are protected.
        #     mls - Multi Level Security protection.
        SELINUXTYPE=${cfg.type}
      '';
    };
  };
}
