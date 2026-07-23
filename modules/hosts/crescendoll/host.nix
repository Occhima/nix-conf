# Host: crescendoll — WSL.
# Plain deferred NixOS module; usable without Den.
{ config, ... }:
{
  flake.modules.nixos.host-crescendoll = {
    imports = with config.flake.modules.nixos; [
      system-base
      accounts
      network
      security-auth
      wsl
    ];

    modules.network.hostName = "crescendoll";
  };
}
