{ lib, config, ... }:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.types) attrs;
  inherit (lib.options) mkOption mkEnableOption;

  cfg = config.modules.system.fs;
in
{
  options.modules.system.fs = {
    default = mkEnableOption "Enable default filesystems";
    swap = mkEnableOption "Enable swap";

    mounts = mkOption {
      type = attrs;
      default = { };
      description = ''
        A list of filesystems available supported by the system
        it will enable services based on what strings are found in the list.

        It would be a good idea to keep vfat and ext4 so you can mount USBs.
      '';
    };
  };

  config = {
    fileSystems = mkMerge [
      (mkIf cfg.default {
        "/" = {
          device = "/dev/disk/by-label/root";
          fsType = "btrfs";
        };

        "/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
        };
      })

      cfg.mounts
    ];

    swapDevices = mkIf cfg.swap [ { device = "/dev/disk/by-label/swap"; } ];
  };
}
