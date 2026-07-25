# feynman: flake output wiring; the package expression lives in
# ./_feynman/package.nix.
{
  perSystem = { pkgs, ... }: {
    packages.feynman = pkgs.callPackage ./_feynman/package.nix { };
  };
}
