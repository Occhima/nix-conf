# docs: flake output wiring; the package expression lives in
# packages/docs/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.docs = pkgs.callPackage ../../packages/docs/package.nix { };
    };
}
