{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.dev.haskell;
in
{
  options.modules.dev.haskell = {
    enable = mkEnableOption "Enable Haskell development tools";
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        haskellPack =
          with pkgs.haskellPackages;
          let
            ps =
              p: with p; [
                async
                base
                containers
                lens
                mtl
                random
                stm
                text
                transformers
                unliftio
              ];
            ghc = ghcWithHoogle ps;
          in
          [
            ghc
            cabal-install
            hlint
            ghcide
            hnix
            stack
            haskell-language-server
          ];
      in
      haskellPack;
  };
}
