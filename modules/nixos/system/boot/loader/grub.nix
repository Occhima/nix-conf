{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr str;

  cfg = config.modules.system.boot.loader;
  cfgGrub = config.modules.system.boot.loader.grub;
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
    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = cfgGrub.device;
        #efiInstallAsRemovable = true;
        theme = pkgs.nixos-grub2-theme;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
