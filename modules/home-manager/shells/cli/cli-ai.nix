{ config, ... }:
{
  flake.modules.homeManager.cli-ai.imports = with config.flake.modules.homeManager; [
    claude-code
    opencode
    aider
    fabric
    jcode
    codegraph
    feynman
  ];
}
