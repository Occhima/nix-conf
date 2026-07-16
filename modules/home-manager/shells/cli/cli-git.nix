{ inputs, ... }:
{
  config.flake.modules.homeManager.cli-git = {
    imports = with inputs.self.modules.homeManager; [
      gh
      lazygit
      jujutsu
      git
    ];
  };
}
