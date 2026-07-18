# Host: steammachine — gaming desktop, AMD/NVIDIA, Ly, 2 monitors, Disko,
# pentesting container, VPN.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  den.hosts.x86_64-linux.steammachine.users.occhima = { };

  den.aspects.steammachine = {
    nixos =
      { host, ... }:
      {
        imports = [
          nixos.gaming-workstation
          nixos.cpu-amd
          nixos.gpu-nvidia
          nixos.login-ly
          nixos.disko-steammachine
          nixos.vpn-openvpn
          nixos.pentesting-container
        ];

        modules.network.hostName = host.hostName;

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

  perSystem = {
    agenix-rekey.nixosConfigurations.steammachine = config.flake.nixosConfigurations.steammachine;
  };
}
