# Aggregate: editors in daily use.
{ config, ... }:
{
  flake.modules.homeManager.editors.imports = with config.flake.modules.homeManager; [
    neovim
    emacs
  ];
}
