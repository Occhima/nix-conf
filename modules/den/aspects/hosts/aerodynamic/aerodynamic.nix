# Host: aerodynamic — laptop, Intel/NVIDIA, Greetd, Disko, impermanence.
{ den, nixos, ... }:
{
  den.aspects.aerodynamic = {
    includes = [
      den.aspects.workstation
    ]
    ++ (map nixos [
      "laptop"
      "cpu-intel"
      "gpu-nvidia"
      "login-greetd"
      "disko-aerodynamic"
    ]);
    nixos = {
      modules.hardware.monitors = {
        primaryMonitorName = "edp1";
        displays.edp1 = {
          output = "eDP-1";
          width = 2560;
          height = 1080;
          refreshRate = 180;
          x = 0;
          y = 0;
        };
      };
      modules.system.boot.loader.grub.device = "/dev/nvme0n1";
    };
  };
}
