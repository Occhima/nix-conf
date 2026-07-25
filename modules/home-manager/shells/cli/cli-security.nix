{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.cli-security.imports = [
    hm.ssh
    hm.gpg
  ];
}
