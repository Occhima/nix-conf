# antigravity: flake output wiring; the package expression lives in
# packages/antigravity/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.antigravity = pkgs.callPackage ../../packages/antigravity/package.nix { };
    };
}
