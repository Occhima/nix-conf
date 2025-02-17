{
  lib,
  self,
  pkgs,
  config,
  ...
}:
let
  inherit (self.lib.custom) ifTheyExist;
in
{
  users.users.occhima = {

    initialPassword = lib.mkDefault "changeme";
    isNormalUser = true;
    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/N9m28W8c9Fs9InErjlNRXCwPe1CR9HafzqjTcSis9"
    ];

    extraGroups = ifTheyExist config [
      "network"
      "networkmanager"
      "systemd-journal"
      "audio"
      "pipewire" # this give us access to the rt limits
      "video"
      "input"
      "plugdev"
      "lp"
      "nix"
      "tss"
      "power"
      "wireshark"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "cloudflared"
    ];

  };

}
