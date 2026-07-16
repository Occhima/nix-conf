{ inputs, ... }:
{
  config.flake.modules.homeManager.cli-ai = {
    imports = with inputs.self.modules.homeManager; [
      claude-code
      opencode
      aider
      fabric
      jcode
      codegraph
      feynman
    ];
  };
}
