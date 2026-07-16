# install-tools: flake output wiring; the package expression lives in
# packages/installer/package.nix.
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.install-tools = pkgs.callPackage ../../packages/installer/package.nix { };
    };
}
