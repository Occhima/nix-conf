# Repo helper scripts (run-vm + the aggregated scripts bundle).
{
  perSystem = { pkgs, ... }: {
    packages = {
      inherit (pkgs.callPackage ./_scripts/package.nix { })
        run-vm
        scripts
        ;
    };
  };
}
