# antigravity: flake output wiring; the package expression lives in
# ./_antigravity/package.nix.
{ ... }:
{
  # Unfree upstream binary.
  flake.allowedUnfreePackages = [ "antigravity" ];

  perSystem =
    { pkgs, ... }:
    {
      packages.antigravity = pkgs.callPackage ./_antigravity/package.nix { };
    };
}
