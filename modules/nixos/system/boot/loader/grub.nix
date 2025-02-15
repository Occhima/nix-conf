{ lib, config, ... }:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr str;
  cfg = config.modules.system.boot.loader.grub;
in
{
  options.modules.system.boot.loader.grub = {
    enable = mkEnableOption "";
    device = mkOption {
      type = nullOr str;
      default = "nodev";
      description = "The device to install the bootloader to.";
    };
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = mkDefault true;
      useOSProber = true;
      efiSupport = true;
      enableCryptodisk = mkDefault false;
      inherit (cfg.grub) device;
      theme = null;
      backgroundColor = null;
      splashImage = null;
    };
  };
}
