# One aspect per plain module, built on demand: `hm "<name>"` wraps
# `flake.modules.homeManager.<name>`, `nixos "<name>"` wraps
# `flake.modules.nixos.<name>`. `den.aspects` keeps only features and bundles.
#
# Functions, not attrsets: den walks includes while building `flake`, so any
# attrset keyed by `flake.modules` names recurses. The aspect identity
# (`hm/<name>`) is stable, so `hasAspect (hm "<name>")` works.
{ config, ... }:
let
  aspect = prefix: class: name: {
    inherit name;
    meta.aspect-chain = [ prefix ];
    ${class}.imports = [ config.flake.modules.${class}.${name} ];
  };
in
{
  _module.args = {
    hm = aspect "hm" "homeManager";
    nixos = aspect "nixos" "nixos";
  };
}
