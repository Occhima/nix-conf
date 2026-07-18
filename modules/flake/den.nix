# Den: hosts, users and output generation — nothing more. Features live
# in plain flake-parts `flake.modules.<class>.<name>` (no den vocabulary);
# only modules/hosts/ and modules/users/ speak den, wiring those modules
# into hosts, users and standalone homes. No namespace: den stays a thin,
# replaceable output layer.
{ inputs, lib, ... }:
{

  flake-file.inputs.den.url = "github:denful/den";

  imports = [ inputs.den.flakeModule ];
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
