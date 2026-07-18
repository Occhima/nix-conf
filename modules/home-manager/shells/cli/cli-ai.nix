{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.cli-ai.imports = [
    hm.claude-code
    hm.opencode
    hm.aider
    hm.fabric
    hm.jcode
    hm.codegraph
    hm.feynman
  ];
}
