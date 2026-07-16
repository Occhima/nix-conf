{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  config.flake.modules.homeManager.feynman = (
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
