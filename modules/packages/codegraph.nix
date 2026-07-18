# codegraph: flake output wiring; the package expression lives in
# ./_codegraph/package.nix.
{
  perSystem =
    { pkgs, ... }:
    {
      packages.codegraph = pkgs.callPackage ./_codegraph/package.nix { };
    };
}
