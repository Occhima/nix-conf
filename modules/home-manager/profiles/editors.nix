# Aggregate: editors in daily use.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.editors.imports = [
    hm.neovim
    hm.emacs
  ];
}
