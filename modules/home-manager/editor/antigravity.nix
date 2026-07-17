{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  occhima.antigravity.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home = {
          packages = [ flakePkgs.${pkgs.stdenv.hostPlatform.system}.antigravity ];
        };
      };
    }
  );
}
