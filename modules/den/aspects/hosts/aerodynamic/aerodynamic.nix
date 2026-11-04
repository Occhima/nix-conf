# Host: aerodynamic — laptop, Intel/NVIDIA, Greetd, Disko, impermanence.
{ config, den, ... }:
{
  den.aspects.aerodynamic = {
    includes = with den.aspects; [
      workstation
      laptop
      cpu-intel
      gpu-nvidia
      login-greetd
    ];
    nixos = {
      imports = [ config.flake.modules.nixos.disko-aerodynamic ];

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
