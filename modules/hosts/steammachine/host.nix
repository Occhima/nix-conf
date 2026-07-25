# Host: steammachine — gaming desktop, AMD/NVIDIA, Ly, 2 monitors, Disko,
# pentesting container, VPN.
# Plain deferred NixOS module; usable without Den.
{ config, ... }: {
  flake.modules.nixos.host-steammachine = {
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
}
