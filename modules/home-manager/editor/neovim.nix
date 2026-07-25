{
  config,
  inputs,
  ...
}:
let
  flakePkgs = config.flake.packages;
in
{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    let
      inherit (inputs) nixvim;
    in
    {
      imports = [
        nixvim.homeModules.nixvim
      ];

      home = {
        packages = [ flakePkgs.${pkgs.stdenv.hostPlatform.system}.nvim ];
      };
    };
}
