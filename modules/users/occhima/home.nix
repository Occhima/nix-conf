# occhima — plain Home Manager module. Hosts and the standalone home get it
# wired through the Den aspect in modules/den/aspects/users/occhima.nix; the
# module itself is Den-free and usable on its own.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.user-occhima = {
    imports = [
      hm.home-base
      hm.shell
      hm.personal-data
      hm.editors
      hm.languages
      hm.desktop
      # Emacs: Doom flavor + daemon/default editor (selected by import).
      hm.emacs-doom
      hm.emacs-daemon
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
  };
}
