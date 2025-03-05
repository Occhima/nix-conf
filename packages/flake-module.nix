{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs.callPackage ./package.nix { })
          run-vm
          scripts
          ;
      };
    };
}
