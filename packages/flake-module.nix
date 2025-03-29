{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs.callPackage ./scripts/package.nix { })
          run-vm
          scripts
          ;
        install-tools = pkgs.callPackage ./installer/package.nix { };
        docs = pkgs.callPackage ./docs/package.nix { };
      };
    };
}
