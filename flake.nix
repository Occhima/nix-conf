{
  description = "My NixOS config";

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {flake-parts-lib, config, options, lib, ...}:
      let
        inherit (flake-parts-lib) importApply;
        flakeModule.default = importApply ./flake-module.nix {
              inherit
                config
                inputs
                options
                lib
                ;
               };
      in
      {
        imports = [flakeModule.default];
      }
    );

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ========= Utilities =========
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = { url = "github:hercules-ci/flake-parts"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems = { url = "github:nix-systems/default"; };



  };
}
