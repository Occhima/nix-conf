# occhima — Den user aspect. Hosts declaring `users.occhima` get this
# environment wired through Den; `den.homes` (standalone.nix) reuses the
# very same aspect for non-NixOS machines. The environment itself is
# composed from plain `flake.modules.homeManager.*` feature modules.
{ config, ... }:
{
  den.aspects.occhima.homeManager = {
    imports = with config.flake.modules.homeManager; [
      home-base
      shell
      data-core
      editors
      languages
      desktop
      # Services
      espanso
      podman
      # Topic profiles
      web
      data
      ai
      dev
      science
      finance
      pentesting
    ];

    home.username = "occhima";
    home.homeDirectory = "/home/occhima";
    modules.editor.emacs = {
      flavor = "doom";
      service = true;
      default = true;
    };
  };
}
