{ config, ... }:
{
  flake.modules.homeManager.cli-security.imports = with config.flake.modules.homeManager; [
    ssh
    gpg
  ];
}
