# Host: crescendoll — WSL.
{ config, ... }:
{
  den.hosts.x86_64-linux.crescendoll.users.occhima = { };

  den.aspects.crescendoll = {
    nixos = {
      imports = with config.flake.modules.nixos; [
        system-base
        accounts
        user-occhima
        network
        security-auth
        wsl
      ];

      modules.network.hostName = "crescendoll";
    };
  };
}
