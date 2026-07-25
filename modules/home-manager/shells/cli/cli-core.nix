{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.cli-core.imports = [
    hm.bat
    hm.eza
    hm.fzf
    hm.ripgrep
    hm.jq
    hm.pandoc
  ];
}
