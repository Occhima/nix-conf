# Host: crescendoll — WSL.
{ config, den, ... }:
{
  den.aspects.crescendoll = {
    includes = with den.aspects; [
      system-base
      wsl
    ];
    nixos = {
      imports = with config.flake.modules.nixos; [
        accounts
        network
        security-auth
      ];
    };
  };
}
