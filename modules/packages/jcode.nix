# jcode: flake output wiring; the package expression lives in
# packages/jcode/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.jcode = pkgs.callPackage ../../packages/jcode/package.nix { };
    };
}
