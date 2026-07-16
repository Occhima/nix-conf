# occhima — Home Manager environment aspect.
# Composed from aggregates (see modules/home-manager/profiles/); importing
# this aspect (integrated via `user-occhima`, or standalone) activates it.
{ config, ... }:
{
  config.flake.modules.homeManager.occhima = {
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
    config = {
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
