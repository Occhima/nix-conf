# codegraph: flake output wiring; the package expression lives in
# packages/codegraph/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.codegraph = pkgs.callPackage ../../packages/codegraph/package.nix { };
    };
}
