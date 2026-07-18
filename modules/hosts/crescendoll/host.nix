# Host: crescendoll — WSL.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  den.hosts.x86_64-linux.crescendoll.users.occhima = { };

  den.aspects.crescendoll = {
    nixos =
      { host, ... }:
      {
        imports = [
          nixos.system-base
          nixos.accounts
          nixos.network
          nixos.security-auth
          nixos.wsl
        ];

        modules.network.hostName = host.hostName;
      };
  };
}
