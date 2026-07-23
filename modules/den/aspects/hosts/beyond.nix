# Den aspect for beyond: wires the plain host module into Den.
{ config, ... }:
{
  den.aspects.beyond.nixos.imports = [ config.flake.modules.nixos.host-beyond ];
}
