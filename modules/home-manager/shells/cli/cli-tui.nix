{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.cli-tui.imports = [
    hm.yazi
    hm.zellij
    hm.fastfetch
  ];
}
