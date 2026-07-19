{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  flake.modules.homeManager.feynman =
    {
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
    };
}
