# docs: flake output wiring; the package expression lives in
# ./_docs/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.docs = pkgs.callPackage ./_docs/package.nix { };
    };
}
