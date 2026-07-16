# Host: beyond — desktop, AMD/NVIDIA, Ly, 2 monitors, Disko, Steam, OOM, VPN.
{ config, inputs, ... }:
{
  flake.modules.nixos.beyond = {
    imports = with config.flake.modules.nixos; [
      system-base
      accounts
      user-occhima
      user-root
      cpu-amd
      gpu-nvidia
      ssd
      bluetooth
      yubikey
      input-devices
      media-sound-pipewire
      media-video
      monitors
      network
      networkmanager
      firewall
      blocker
      wireless
      vpn-openvpn
      boot-grub
      boot-kernel
      boot-plymouth
      display-wayland
      display-portals
      login-ly
      impermanence
      disko-beyond
      podman
      agenix
      systemd
      oom
      firmware
      flatpak
      steam
      ssh
      appimage
      nix-ld
      security-auth
      security-kernel
      graphical
      desktop
    ];
    config = {
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

  flake.nixosConfigurations.beyond = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config.flake.modules.nixos.beyond ];
  };

  perSystem = _: {
    agenix-rekey.nixosConfigurations.beyond = config.flake.nixosConfigurations.beyond;
  };
}
