# ampcode: flake output wiring; the package expression lives in
# packages/ampcode/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.ampcode = pkgs.callPackage ../../packages/ampcode/package.nix { };
    };
}
