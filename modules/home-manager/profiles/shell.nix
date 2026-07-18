# Aggregate: the complete interactive shell environment.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.shell.imports = [
    hm.shell-zsh
    hm.prompt-starship
    hm.cli-core
    hm.cli-git
    hm.cli-shell
    hm.cli-tui
    hm.cli-security
    hm.cli-dev
    hm.password-store
  ];
}
