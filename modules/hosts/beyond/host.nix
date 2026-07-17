# Host: beyond — gaming desktop, AMD/NVIDIA, Ly, 2 monitors, Disko, VPN.
{ config, ... }:
{
  den.hosts.x86_64-linux.beyond.users.occhima = { };

  den.aspects.beyond = {
    nixos = {
      imports = with config.flake.modules.nixos; [
        gaming-workstation
        cpu-amd
        gpu-nvidia
        login-ly
        disko-beyond
        vpn-openvpn
      ];

      modules.network.hostName = "beyond";

      # agenix-rekey host identity lives next to the host, not in a registry.
      age.rekey.hostPubkey = builtins.readFile ./host.pub;

      modules.hardware.monitors = {
        primaryMonitorName = "dp1";
        displays.dp1 = {
          output = "DP-1";
          mode = "2560x1080@180";
          position = "0x0";
        };
        displays.hdmi = {
          output = "HDMI-A-1";
          mode = "1920x1080@180";
          position = "2560x0";
        };
      };
    };
  };

  perSystem = _: {
    agenix-rekey.nixosConfigurations.beyond = config.flake.nixosConfigurations.beyond;
  };
}
