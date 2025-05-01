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
  config = mkIf (cfg.type == "amd") {
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
