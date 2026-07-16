# Host: beyond — desktop, AMD/NVIDIA, Ly, 2 monitors, Disko, Steam, OOM, VPN.
{
  inputs,
  ...
}:
{
  config.flake.modules.nixos.beyond = {
    imports = with inputs.self.modules.nixos; [
      system-base
      accounts
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
      disko
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
      modules.accounts = {
        enabledUsers = [
          "occhima"
          "root"
        ];
        mainUser = "occhima";
      };
      modules.network.hostName = "beyond";
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
}
