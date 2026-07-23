# Den aspect for voyager: wires the plain host module into Den.
{ config, ... }:
{
  den.aspects.voyager.nixos.imports = [ config.flake.modules.nixos.host-voyager ];
}
