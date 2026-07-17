# Host: steammachine — gaming desktop, AMD/NVIDIA, Ly, 2 monitors, Disko,
# pentesting container, VPN.
{ config, ... }:
{
  den.hosts.x86_64-linux.steammachine.users.occhima = { };

  den.aspects.steammachine = {
    nixos = {
      imports = with config.flake.modules.nixos; [
        gaming-workstation
        cpu-amd
        gpu-nvidia
        login-ly
        disko-steammachine
        vpn-openvpn
        pentesting-container
      ];

      modules.network.hostName = "steammachine";

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
    agenix-rekey.nixosConfigurations.steammachine = config.flake.nixosConfigurations.steammachine;
  };
}
