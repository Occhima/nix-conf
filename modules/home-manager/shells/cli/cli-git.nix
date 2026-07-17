{ config, ... }:
{
  flake.modules.homeManager.cli-git.imports = with config.flake.modules.homeManager; [
      gh
      lazygit
      jujutsu
      git
    ];
}
