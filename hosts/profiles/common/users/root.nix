{
  lib,
  config,
  self,
  pkgs,
  ...
}:
let
  inherit (self.lib.custom) ifTheyExist;
in
{

  users = {
    mutableUsers = false;

    users.root = {
      initialPassword = lib.mkDefault "changeme";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/N9m28W8c9Fs9InErjlNRXCwPe1CR9HafzqjTcSis9"
      ];
      shell = pkgs.bash;

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

  };

}
