{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  config.flake.modules.homeManager.antigravity = (
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
