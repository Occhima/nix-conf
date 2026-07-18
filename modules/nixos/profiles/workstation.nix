# Aggregate: the full stack shared by every physical workstation
# (aerodynamic, beyond, steammachine). Host aspects include this and add
# only what identifies the machine: CPU/GPU, login manager, disko layout
# and machine-specific services. gaming-workstation builds on top.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.workstation.imports = [
    nixos.system-base
    nixos.accounts
    nixos.user-root
    nixos.ssd
    nixos.bluetooth
    nixos.yubikey
    nixos.input-devices
    nixos.media-sound-pipewire
    nixos.media-video
    nixos.monitors
    nixos.network
    nixos.networkmanager
    nixos.firewall
    nixos.blocker
    nixos.wireless
    nixos.boot-grub
    nixos.boot-kernel
    nixos.boot-plymouth
    nixos.display-wayland
    nixos.display-portals
    nixos.impermanence
    nixos.podman-host
    nixos.agenix
    nixos.systemd
    nixos.firmware
    nixos.flatpak-daemon
    nixos.sshd
    nixos.appimage
    nixos.security-auth
    nixos.security-kernel
    nixos.graphical
    nixos.desktop
  ];
}
