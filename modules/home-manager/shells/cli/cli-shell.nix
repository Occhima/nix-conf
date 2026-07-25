{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.cli-shell.imports = [
    hm.atuin
    hm.zoxide
    hm.direnv
    hm.nix-your-shell
    hm.navi
    hm.pay-respects
  ];
}
