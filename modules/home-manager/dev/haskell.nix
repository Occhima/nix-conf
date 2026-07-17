{ ... }:
{
  config.occhima.haskell.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
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
  );
}
