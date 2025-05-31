{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.hardware.cpu;
in
{
  config = mkIf (cfg.type == "intel") {
    hardware.cpu.intel.updateMicrocode = true;
    hardware.enableRedistributableFirmware = true;
    # hardware.enableAllFirmware = true;
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
