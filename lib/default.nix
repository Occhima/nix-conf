nixpkgs:
let
  lib = nixpkgs.lib;
  modules = import ./modules.nix { inherit lib; };
  attributes = import ./attrsets.nix { inherit lib; };
  umport = import ./umport.nix { inherit (nixpkgs) lib; };

  allModules = modules // attributes // umport;

  mkLib =
    pkgs:
    pkgs.lib.extend (
      _: _: {
        custom = allModules;
      }
    );
  customLib = (mkLib nixpkgs);
in
customLib
