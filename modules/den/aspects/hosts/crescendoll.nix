# Den aspect for crescendoll: wires the plain host module into Den.
{ config, ... }: {
  den.aspects.crescendoll.nixos.imports = [ config.flake.modules.nixos.host-crescendoll ];
}
