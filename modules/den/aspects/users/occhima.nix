{ config, den, ... }:
let
  inherit (config.flake.lib.custom) ifTheyExist;
in
{
  den.aspects.occhima = {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        modules.accounts.mainUser = lib.mkDefault "occhima";

        users.users.occhima = {
          initialPassword = "changeme";
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

    includes = with den.aspects; [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects
      home-base
      shell
      personal-data
      editors
      emacs
      espanso
      languages
      web
      data
      dev
      science
      finance
      ai
      podman
      (den.lib.policy.when
        (
          {
            host ? null,
            ...
          }:
          host == null || host.hasAspect den.aspects.graphical
        )
        {
          includes = [ den.aspects.desktop ];
          homeManager.modules.desktop.apps.flatpak.packages = [
            "com.github.tchx84.Flatseal"
            # "com.github.flxzt.rnote"
          ];
        }
      )
    ];
  };
}
