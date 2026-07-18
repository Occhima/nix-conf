# occhima — Den user aspect. Hosts declaring `users.occhima` get this
# environment wired through Den; `den.homes` (standalone.nix) reuses the
# very same aspect for non-NixOS machines. The environment itself is
# composed from plain `flake.modules.homeManager.*` feature modules.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  den.aspects.occhima = {
    nixos =
      { ... }:
      {
        imports = [ config.flake.modules.nixos.user-occhima ];
      };

    homeManager = {
      imports = [
        hm.home-base
        hm.shell
        hm.personal-data
        hm.editors
        hm.languages
        hm.desktop
        # Services
        hm.espanso
        hm.podman
        # Topic profiles
        hm.web
        hm.data
        hm.ai
        hm.dev
        hm.science
        hm.finance
        hm.pentesting
      ];

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
