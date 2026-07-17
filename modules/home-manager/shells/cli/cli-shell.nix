{ config, ... }:
{
  flake.modules.homeManager.cli-shell.imports = with config.flake.modules.homeManager; [
      atuin
      zoxide
      direnv
      nix-your-shell
      navi
      pay-respects
    ];
}
