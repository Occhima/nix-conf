# Aggregate: editors in daily use. Emacs flavors are selected by import
# (emacs-doom / emacs-vanilla), not by this profile.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.editors.imports = [
    hm.neovim
  ];
}
