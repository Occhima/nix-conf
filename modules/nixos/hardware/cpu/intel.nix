{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.hardware.cpu;
in
{
  config = mkIf (cfg.type == "intel") {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = [
        "kvm-intel"
      ];
      kernelParams = [
        "i915.fastboot=1"
        "enable_gvt=1"
      ];
    };
  };
}
