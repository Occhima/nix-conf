{ self, ... }:
let
  inherit (self.lib.occhima) nixModulesFromDir;

  # Root modules per class. Feature modules are discovered automatically
  # (see lib/discovery.nix for the rules) and expose their functionality
  # exclusively through options — importing the root module makes every
  # option available, enabling none.
  nixosRoot = {
    _class = "nixos";
    imports = nixModulesFromDir ../nixos;
  };

  isoRoot = {
    _class = "nixos";
    imports = nixModulesFromDir ../iso;
  };

  homeManagerRoot = {
    _class = "homeManager";
    imports = nixModulesFromDir ../home-manager;
  };
in
{
  flake = {
    modules = {
      nixos = {
        default = nixosRoot;
        iso = isoRoot;
      };
      homeManager.default = homeManagerRoot;
    };

    # Compatibility aliases for the historical export names. The old
    # `common` tree is merged into the default root; remove these once
    # nothing references them anymore.
    nixosModules = {
      default = nixosRoot;
      common = nixosRoot;
      nixos = nixosRoot;
      iso = isoRoot;
    };
    homeModules.default = homeManagerRoot;
  };
}
