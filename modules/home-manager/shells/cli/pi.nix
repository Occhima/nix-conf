{ config, ... }:
let
  aiAssets = config.flake.lib.custom.aiAssets;
in
{
  flake.modules.homeManager.pi = {
    programs.pi-coding-agent = {
      enable = true;
      context = aiAssets.agentsMd;
    };

    programs.git.ignores = [ ".pi/" ];
  };
}
