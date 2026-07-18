{ config, ... }:
{
  flake.modules.homeManager.cli-core.imports = with config.flake.modules.homeManager; [
    bat
    eza
    fzf
    ripgrep
    jq
    pandoc
  ];
}
