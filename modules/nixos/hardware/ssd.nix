{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.hardware.ssd;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
# hasZfs = any (x: x ? fsType && x.fsType == "zfs") (attrValues config.fileSystems);
{
  options.modules.hardware.ssd = {
    enable = mkEnableOption "SSD optimizations";
  };

  config = mkIf cfg.enable {
    services = {
      # Enable TRIM for SSDs, unless ZFS is used
      fstrim.enable = mkDefault false;

      #   # Enable ZFS TRIM if ZFS is used
      #   zfs.trim.enable = mkDefault hasZfs;
    };

    # Enable NVMe module support
    boot.initrd.availableKernelModules = [ "nvme" ];
  };
}
