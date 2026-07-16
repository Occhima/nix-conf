# feynman: flake output wiring; the package expression lives in
# packages/feynman/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.feynman = pkgs.callPackage ../../packages/feynman/package.nix { };
    };
}
