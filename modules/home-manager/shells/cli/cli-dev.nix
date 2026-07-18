{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.cli-dev.imports = [ hm.distrobox ];
}
