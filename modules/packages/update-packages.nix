# update-packages: flake output wiring; the package expression lives in
# ./_update-packages/package.nix.
{
  perSystem =
    { pkgs, ... }:
    {
      packages.update-packages = pkgs.callPackage ./_update-packages/package.nix { };
    };
}
