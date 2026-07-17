{ occhima, ... }:
{
  config.occhima.cli-git.includes = with occhima; [
      gh
      lazygit
      jujutsu
      git
    ];
}
