{ ... }:
{
  config.flake.modules.nixos.cpu-intel = {
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
