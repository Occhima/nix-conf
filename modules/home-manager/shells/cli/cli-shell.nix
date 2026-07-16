{ inputs, ... }:
{
  config.flake.modules.homeManager.cli-shell = {
    imports = with inputs.self.modules.homeManager; [
      atuin
      zoxide
      direnv
      nix-your-shell
      navi
      pay-respects
    ];
  };
}
