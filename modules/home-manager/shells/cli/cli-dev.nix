{ inputs, ... }:
{
  config.flake.modules.homeManager.cli-dev = {
    imports = with inputs.self.modules.homeManager; [ distrobox ];
  };
}
