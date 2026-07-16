{ inputs, ... }:
{
  config.flake.modules.homeManager.cli-core = {
    imports = with inputs.self.modules.homeManager; [
      bat
      eza
      fzf
      ripgrep
      jq
      pandoc
    ];
  };
}
