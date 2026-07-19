# ampcode: flake output wiring; the package expression lives in
# ./_ampcode/package.nix.
{ ... }:
{
  # Unfree upstream binary.
  flake.allowedUnfreePackages = [ "ampcode" ];

  perSystem =
    { pkgs, ... }:
    {
      packages.ampcode = pkgs.callPackage ./_ampcode/package.nix { };
    };
}
