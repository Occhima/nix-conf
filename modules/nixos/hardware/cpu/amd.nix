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

    boot = {
      kernelModules = [
        "kvm-amd"
        # "amd-pstate"
      ];

      kernelParams = [
      ];
    };
  };
}
