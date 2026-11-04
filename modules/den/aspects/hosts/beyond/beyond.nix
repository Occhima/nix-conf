# Host: beyond — gaming desktop, AMD/NVIDIA, greetd+ReGreet, 2 monitors, Disko, VPN.
{ config, den, ... }:
{
  den.aspects.beyond = {
    includes = with den.aspects; [
      gaming-workstation
      cpu-amd
      gpu-nvidia
      login-silentsddm
    ];
    nixos = {
      imports = with config.flake.modules.nixos; [
        disko-beyond
        # vpn-openvpn
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
