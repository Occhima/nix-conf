{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  occhima.feynman.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    let
      pkg = flakePkgs.${pkgs.stdenv.hostPlatform.system}.feynman;
    in
    {
      config = {
        home.packages = [ pkg ];
      };
    }
  );
}
