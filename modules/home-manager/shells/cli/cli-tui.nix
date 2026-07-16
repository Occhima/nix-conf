{ inputs, ... }:
{
  config.flake.modules.homeManager.cli-tui = {
    imports = with inputs.self.modules.homeManager; [
      yazi
      zellij
      fastfetch
    ];
  };
}
