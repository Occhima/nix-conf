{ config, lib, ... }:
let
  pubkeyOf = name: ../aspects/hosts/${name}/host.pub;
  hostNames = lib.concatMap builtins.attrNames (builtins.attrValues config.den.hosts);
  rekeyed = builtins.filter (name: builtins.pathExists (pubkeyOf name)) hostNames;
in
{
  den.aspects = lib.genAttrs rekeyed (name: {
    nixos.age.rekey.hostPubkey = builtins.readFile (pubkeyOf name);
  });

  perSystem.agenix-rekey.nixosConfigurations = lib.genAttrs rekeyed (
    name: config.flake.nixosConfigurations.${name}
  );
}
