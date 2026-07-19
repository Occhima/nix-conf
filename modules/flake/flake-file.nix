{ inputs, ... }: {

  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  imports = [ inputs.flake-file.flakeModules.dendritic ];

  flake-file.description = "My dendritic NixOS config";

}
