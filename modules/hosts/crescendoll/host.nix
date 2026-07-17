# Host: crescendoll — WSL.
{ occhima, ... }:
{
  den.hosts.x86_64-linux.crescendoll.users.occhima = { };

  den.aspects.crescendoll = {
    includes = with occhima; [
      system-base
      accounts
      user-occhima
      network
      security-auth
      wsl
    ];

    nixos = {
      modules.network.hostName = "crescendoll";
    };
  };
}
