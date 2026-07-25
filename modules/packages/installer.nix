# install-tools: flake output wiring; the package expression lives in
# ./_installer/package.nix.
{
  perSystem = { pkgs, ... }: {
    packages.install-tools = pkgs.callPackage ./_installer/package.nix { };
  };
}
