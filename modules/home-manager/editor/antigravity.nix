{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  flake.modules.homeManager.antigravity = (
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
