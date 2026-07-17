# Aggregate: the complete interactive shell environment.
{ occhima, ... }:
{
  config.occhima.shell.includes = with occhima; [
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
