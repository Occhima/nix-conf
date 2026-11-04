{ config, lib, ... }:
let
  hosts = lib.mergeAttrsList (lib.attrValues config.den.hosts);
in
{
  flake.lib.den.hostHasAspect = host: aspect: hosts.${host}.hasAspect config.den.aspects.${aspect};
}
