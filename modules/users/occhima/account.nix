# occhima — NixOS account aspect. Importing `user-occhima` on a host
# creates the account and wires the integrated Home Manager environment.
{ config, ... }:
let
  inherit (config.flake.lib.custom) ifTheyExist;
  occhimaHome = config.flake.modules.homeManager.occhima;
in
{
  flake.modules.nixos.user-occhima =
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

      home-manager.users.occhima.imports = [ occhimaHome ];
    };
}
