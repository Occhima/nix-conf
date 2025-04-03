{
  self,
  ...
}:

let
  inherit (self) lib;
  inherit (lib.custom) collectNixModulePaths;

  mkModule =
    {
      class ? "nixos",
      name,

    }:
    {
      _class = class;
      imports = collectNixModulePaths ./${name};
    };

in
{

  flake = {
    nixosModules = {
      common = mkModule { name = "common"; };
      nixos = mkModule { name = "nixos"; };
      iso = mkModule { name = "iso"; };
    };

    homeModules = {
      default = mkModule {
        class = "homeManager";
        name = "home-manager";
      };
    };
  };
}
