{ inputs, ... }:
{
  config.flake.modules.homeManager.cli-security = {
    imports = with inputs.self.modules.homeManager; [
      ssh
      gpg
    ];
  };
}
