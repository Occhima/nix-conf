# jcode: flake output wiring; the package expression lives in
# ./_jcode/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.jcode = pkgs.callPackage ./_jcode/package.nix { };
    };
}
