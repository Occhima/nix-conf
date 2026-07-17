# occhima — NixOS account. Den attaches the Home Manager environment for
# hosts that declare `users.occhima`; this aspect only creates the account.
{ config, ... }:
let
  inherit (config.flake.lib.custom) ifTheyExist;
in
{
  occhima.user-occhima.nixos =
    { config, lib, pkgs, ... }:
    {
      modules.accounts.mainUser = lib.mkDefault "occhima";

      users.users.occhima = {
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
      };
    };
}
