{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.hardware.ssd;
  inherit (lib) mkEnableOption mkIf;
in
# hasZfs = any (x: x ? fsType && x.fsType == "zfs") (attrValues config.fileSystems);
{
  options.modules.hardware.ssd = {
    enable = mkEnableOption "SSD optimizations";
  };

  config = mkIf cfg.enable {
    zramSwap.enable = true;
    boot.initrd.availableKernelModules = [ "nvme" ];
  };
}
