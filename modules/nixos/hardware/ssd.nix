{ ... }:
# hasZfs = any (x: x ? fsType && x.fsType == "zfs") (attrValues config.fileSystems);
{
  config.occhima.ssd.nixos = {
    zramSwap.enable = true;
    boot.initrd.availableKernelModules = [ "nvme" ];
  };
}
