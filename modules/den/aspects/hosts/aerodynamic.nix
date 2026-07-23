# Den aspect for aerodynamic: wires the plain host module into Den.
{ config, ... }:
{
  den.aspects.aerodynamic.nixos.imports = [ config.flake.modules.nixos.host-aerodynamic ];
}
