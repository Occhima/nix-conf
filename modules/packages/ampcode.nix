# ampcode: flake output wiring; the package expression lives in
# ./_ampcode/package.nix.
{ ... }:
{
  nixpkgs.allowedUnfree = [
    "ampcode"
  ];

  # Unfree upstream binary.
  perSystem =
    { pkgs, ... }:
    {
      packages.ampcode = pkgs.callPackage ./_ampcode/package.nix { };
    };
}
