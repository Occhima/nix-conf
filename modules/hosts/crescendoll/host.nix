# Host: crescendoll — WSL.
{ config, inputs, ... }:
{
  flake.modules.nixos.crescendoll = {
    imports = with config.flake.modules.nixos; [
      system-base
      accounts
      user-occhima
      network
      security-auth
      wsl
    ];
    config = {
      modules.network.hostName = "crescendoll";
    };
  };

  flake.nixosConfigurations.crescendoll = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config.flake.modules.nixos.crescendoll ];
  };
}
