{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr str;

  cfg = config.modules.system.boot.loader;
in
{
  options.modules.system.boot.loader.grub = {
    device = mkOption {
      type = nullOr str;
      default = "nodev";
      description = "The device to install the bootloader to";
    };
  };

  config = mkIf (cfg.type == "grub") {
    boot.loader.grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      enableCryptodisk = mkDefault false;
      device = cfg.grub.device;
      theme = pkgs.nixos-grub2-theme;
      backgroundColor = null;
      splashImage = null;
    };
  };
}
