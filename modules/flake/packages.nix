_: {
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs.callPackage ../../packages/scripts/package.nix { })
          run-vm
          scripts
          ;
        install-tools = pkgs.callPackage ../../packages/installer/package.nix { };
        docs = pkgs.callPackage ../../packages/docs/package.nix { };
        nyxt-source = pkgs.callPackage ../../packages/nyxt/package.nix { };
        antigravity = pkgs.callPackage ../../packages/antigravity/package.nix { };
        jcode = pkgs.callPackage ../../packages/jcode/package.nix { };
        ampcode = pkgs.callPackage ../../packages/ampcode/package.nix { };
        update-packages = pkgs.callPackage ../../packages/update-packages/package.nix { };
        codegraph = pkgs.callPackage ../../packages/codegraph/package.nix { };
        feynman = pkgs.callPackage ../../packages/feynman/package.nix { };
      };
    };
}
