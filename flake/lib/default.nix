nixpkgs:
let
  lib = nixpkgs.lib;
  modules = import ./modules.nix { inherit lib; };
  attributes = import ./attrsets.nix { inherit lib; };
  nixos = import ./nixos.nix { inherit lib; };

  allModules = lib.foldl (acc: x: acc // x) { } [
    modules
    attributes
    nixos
  ];

  mkLib = pkgs: pkgs.lib.extend (_: _: { custom = allModules; });
  customLib = (mkLib nixpkgs);
in
customLib
