{
  config,
  den,
  hm,
  ...
}:
let
  inherit (config.flake.lib.custom) ifTheyExist;
in
{
  den.aspects.occhima = {
    user =
      { osConfig, ... }:
      {
        initialPassword = "changeme";
        linger = true;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/N9m28W8c9Fs9InErjlNRXCwPe1CR9HafzqjTcSis9"
        ];
        extraGroups = ifTheyExist osConfig [
          "systemd-journal"
          "audio"
          "video"
          "input"
          "nix"
          "docker"
          "libvirtd"
          "kvm"
        ];
      };

    provides.to-hosts.nixos =
      { lib, ... }:
      {
        modules.accounts.mainUser = lib.mkDefault "occhima";
      };

    includes = with den.aspects; [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      (hm "home")
      (hm "neovim")
      (hm "espanso")
      (hm "web")
      (hm "data")
      (hm "dev")
      (hm "science")
      (hm "finance")
      shell
      personal-data
      emacs
      languages
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
