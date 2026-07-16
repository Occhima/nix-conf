# Aggregate: editors in daily use.
{ config, ... }:
{
  config.flake.modules.homeManager.editors = {
    imports = with config.flake.modules.homeManager; [
      neovim
      emacs
    ];
  };
}
