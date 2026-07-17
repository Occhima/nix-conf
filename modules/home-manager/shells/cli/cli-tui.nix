{ config, ... }:
{
  flake.modules.homeManager.cli-tui.imports = with config.flake.modules.homeManager; [
      yazi
      zellij
      fastfetch
    ];
}
