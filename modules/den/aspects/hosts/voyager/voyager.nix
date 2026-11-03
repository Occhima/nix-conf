# Host: voyager — installer ISO image builder, not a real machine.
{ den, ... }:
{
  den.aspects.voyager = {
    includes = [ den.aspects.iso-base ];
  };
}
