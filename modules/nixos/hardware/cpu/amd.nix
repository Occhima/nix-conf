{ ... }:
{
  flake.modules.nixos.cpu-amd = {
    hardware.cpu.amd.updateMicrocode = true;
    hardware.enableRedistributableFirmware = true;
    boot = {
      # kernelModules = [
      #   "kvm-amd"
      #
      # ];

      kernelParams = [
        "amd-pstate=active"
      ];
    };
  };
}
