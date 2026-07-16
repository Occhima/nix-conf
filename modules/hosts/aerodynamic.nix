# Host: aerodynamic — laptop, Intel/NVIDIA, Greetd, Disko, impermanence.
{
  inputs,
  ...
}:
{
  config.flake.modules.nixos.aerodynamic = {
    imports = with inputs.self.modules.nixos; [
      system-base
      accounts
      cpu-intel
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
      boot-grub
      boot-kernel
      boot-plymouth
      display-wayland
      display-portals
      login-greetd
      impermanence
      disko
      docker
      podman
      agenix
      systemd
      firmware
      flatpak
      ssh
      appimage
      security-auth
      security-kernel
      laptop
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
      modules.network.hostName = "aerodynamic";
      modules.hardware.monitors = {
        primaryMonitorName = "edp1";
        displays.edp1 = {
          output = "eDP-1";
          mode = "2560x1080@180";
          position = "0x0";
        };
      };
      modules.system.boot.loader.grub.device = "/dev/nvme0n1";
    };
  };
}
