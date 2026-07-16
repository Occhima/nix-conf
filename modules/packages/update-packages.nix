# update-packages: flake output wiring; the package expression lives in
# packages/update-packages/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.update-packages = pkgs.callPackage ../../packages/update-packages/package.nix { };
    };
}
