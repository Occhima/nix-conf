# Host: steammachine — gaming desktop, AMD/NVIDIA, greetd+ReGreet, 2 monitors, Disko,
{ config, den, ... }:
{
  den.aspects.steammachine = {
    includes = [ den.aspects.gaming-workstation ];
    nixos = {
      imports = with config.flake.modules.nixos; [
        cpu-amd
        gpu-nvidia
        login-regreet
        disko-steammachine
        # vpn-openvpn
        pentesting-container
      ];

      modules.hardware.monitors = {
        primaryMonitorName = "dp1";
        displays.dp1 = {
          output = "DP-1";
          width = 2560;
          height = 1080;
          refreshRate = 180;
          x = 0;
          y = 0;
        };
        displays.hdmi = {
          output = "HDMI-A-1";
          width = 1920;
          height = 1080;
          refreshRate = 180;
          x = 2560;
          y = 0;
        };
      };
    };
  };
}
