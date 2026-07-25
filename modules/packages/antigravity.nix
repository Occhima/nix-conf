# antigravity: flake output wiring; the package expression lives in
# ./_antigravity/package.nix.
{ ... }: {
  nixpkgs.allowedUnfree = [
    "antigravity"
  ];

  # Unfree upstream binary.
  perSystem = { pkgs, ... }: {
    packages.antigravity = pkgs.callPackage ./_antigravity/package.nix { };
  };
}
