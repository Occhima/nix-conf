{
  description = "My NixOS config";

  outputs = { flake-parts, nixpkgs, ... }@inputs:

    flake-parts.lib.mkFlake { inherit inputs; }

    {

      # NOTE: For debugging, see:
      # https://flake.parts/debug
      # debug = true;

      systems = [ "x86_64-linux" ];

      imports = [ inputs.flake-parts.flakeModules.partitions ./tests ];
      flake = {
        lib = import ./lib { inherit (nixpkgs) lib; };
        tests = {
          test = {
            expr = "a-b-c";
            expected = "a-b-c";
          };
        };
      };

      # partitions
      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
      };

      partitions = {
        dev = {
          extraInputsFlake = ./dev;
          module.imports = [ ./dev/flake-module.nix ];
        };

      };

    };

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

    nix-unit = {
      url = "github:nix-community/nix-unit";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

  };
}
