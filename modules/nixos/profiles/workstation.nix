# Aspect: the full stack shared by every physical workstation
# (aerodynamic, beyond, steammachine). Host aspects include this and add
# only what identifies the machine: CPU/GPU, login manager, disko layout
# and machine-specific services. gaming-workstation builds on top.
{ occhima, ... }:
{
  config.occhima.workstation.includes = with occhima; [
      system-base
      accounts
      user-occhima
      user-root
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
      impermanence
      podman
      agenix
      systemd
      firmware
      flatpak
      ssh
      appimage
      security-auth
      security-kernel
      graphical
      desktop
    ];
}
