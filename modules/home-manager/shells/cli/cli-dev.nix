{ config, ... }:
{
  config.flake.modules.homeManager.cli-dev = {
    imports = with config.flake.modules.homeManager; [ distrobox ];
  };
}
