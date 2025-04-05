# Stolen from: github.com/montchr/dotfield
# TODO ....
{
  self,
  lib,
  ...
}:
let
  inherit (self.lib.colmena) mkNode metaFor;
  l = lib // builtins;

  configurations = l.removeAttrs self.nixosConfigurations [ "bootstrap-graphical" ];

  mkNode' = n: mkNode configurations.${n} n;

  mkHive = nodes: (l.mapAttrs mkNode' nodes) // (metaFor (l.intersectAttrs nodes configurations));
in
{
  flake.colmena = mkHive {
    sus = {
      tags = [
      ];
    };
  };
}
