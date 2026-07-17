{ ... }:
# hasZfs = any (x: x ? fsType && x.fsType == "zfs") (attrValues config.fileSystems);
{
  flake.modules.nixos.ssd = {
    zramSwap.enable = true;
    boot.initrd.availableKernelModules = [ "nvme" ];
  };
}
