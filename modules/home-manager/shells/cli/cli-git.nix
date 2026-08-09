{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.cli-git.imports = [
    hm.gh
    hm.gitbutler
    hm.lazygit
    hm.jujutsu
    hm.git
  ];
}
