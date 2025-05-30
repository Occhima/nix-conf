{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.custom) ifTheyExist;
in
{
  initialPassword = "changeme";
  isNormalUser = true;
  linger = true;

  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/N9m28W8c9Fs9InErjlNRXCwPe1CR9HafzqjTcSis9"
  ];
  shell = pkgs.zsh;
  extraGroups = ifTheyExist config [
    "networkmanager"
    "systemd-journal"
    "audio"
    "video"
    "input"
    "nix"
    "docker"
    "wheel"
    "libvirtd"
    "kvm"
  ];
}
