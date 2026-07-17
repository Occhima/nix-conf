# occhima — Den user aspect. Hosts declaring `users.occhima` get this
# environment wired through Den; `den.homes` (standalone.nix) reuses the
# very same aspect for non-NixOS machines.
{ occhima, ... }:
{
  den.aspects.occhima = {
    includes = with occhima; [
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

    homeManager = {
      home.username = "occhima";
      home.homeDirectory = "/home/occhima";
      modules.editor.emacs = {
        flavor = "doom";
        service = true;
        default = true;
      };
    };
  };
}
