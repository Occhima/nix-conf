{
  description = "My NixOS config";

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
    ({ flake-parts-lib, withSystem, config, options, lib, ... }:
      let
        importApply = module:
          flake-parts-lib.importApply module {
            localFlake = { inherit withSystem config options inputs lib; };
          };

        flakeModule = import ./flake-module.nix { inherit importApply lib; };

      in {

        # NOTE: For debugging, see:
        # https://flake.parts/debug
        # debug = true;

        imports = builtins.attrValues flakeModule;

        systems = [ "x86_64-linux" ];
      });

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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.flake-parts.follows = "flake-parts";
    };

    hyprland = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };

    # Nix Format.
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-parts.follows = "flake-parts";
      };
    };

    nix-unit = {
      url = "github:nix-community/nix-unit";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        # flake-parts.follows = "flake-parts";
      };
    };
  };
}
