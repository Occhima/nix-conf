{

  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.modules.system.boot.loader.systemd;
in
{
  options.modules.system.boot.loader.systemd = {
    enable = mkEnableOption "enable systemd boot";
    memtest = {
      enable = mkEnableOption "memtest86+";
      package = mkPackageOption pkgs "memtest86plus" { };
    };
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot =
      {
        enable = mkDefault true;
        configurationLimit = 15; # prevent "too many" configuration from showing up on the boot menu
        consoleMode = mkDefault "max"; # the default is "keep"

        # Fix a security hole. See desc in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
        editor = false;
      }
      // optionalAttrs cfg.memtest.enable {
        extraFiles."efi/memtest86plus/memtest.efi" = "${cfg.boot.memtest.package}/memtest.efi";
        extraEntries."memtest86plus.conf" = ''
          title MemTest86+
          efi   /efi/memtest86plus/memtest.efi
        '';
      };
  };
}
