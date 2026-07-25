# Host: beyond — gaming desktop, AMD/NVIDIA, Ly, 2 monitors, Disko, VPN.
# Plain deferred NixOS module; usable without Den.
{ config, ... }: {
  flake.modules.nixos.host-beyond = {
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
