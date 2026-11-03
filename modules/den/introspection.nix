{ config, ... }:
{
  flake.lib.den.hostHasAspect =
    host: aspect: config.den.hosts.x86_64-linux.${host}.hasAspect config.den.aspects.${aspect};
}
