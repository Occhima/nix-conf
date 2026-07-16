# Repo helper scripts (run-vm + the aggregated scripts bundle).
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs.callPackage ../../packages/scripts/package.nix { })
          run-vm
          scripts
          ;
      };
    };
}
