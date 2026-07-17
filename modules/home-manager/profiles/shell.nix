# Aggregate: the complete interactive shell environment.
{ config, ... }:
{
  flake.modules.homeManager.shell.imports = with config.flake.modules.homeManager; [
      shell-zsh
      prompt-starship
      cli-core
      cli-git
      cli-shell
      cli-tui
      cli-security
      cli-dev
      password-store
    ];
}
