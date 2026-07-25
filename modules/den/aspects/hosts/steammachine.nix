# Den aspect for steammachine: wires the plain host module into Den.
{ config, ... }: {
  den.aspects.steammachine.nixos.imports = [ config.flake.modules.nixos.host-steammachine ];
}
