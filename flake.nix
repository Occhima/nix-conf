{
  description = "My NixOS config";

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        config,
        options,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (flake-parts-lib) importApply;
        localFlake = {
          inherit
            config
            inputs
            options
            lib
            pkgs
            ;
        };
        flakeModule = import ./flake-module.nix {
          inherit localFlake importApply;
        };
      in
      {
        imports = [ flakeModule ];

        # flake = {
        # inherit flakeModule;
        # };

      }
    );

  inputs = {
    # Sources
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    # ========= Utilities =========
    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "github";
      owner = "cachix";
      repo = "git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };

    nur = {
      type = "github";
      owner = "nix-community";
      repo = "NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };

    # Sec (commented out)
    # agenix-rekey = {
    #   type = "github";
    #   owner = "oddlama";
    #   repo = "agenix-rekey";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "nixpkgs";
      };
    };

    # sops (commented out)
    # sops = {
    #   type = "github";
    #   owner = "Mic92";
    #   repo = "sops-nix";
    # };

    # Deployment tools
    colmena = {
      type = "github";
      owner = "zhaofengli";
      repo = "colmena";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Utility for importing modules
    haumea = {
      type = "github";
      owner = "nix-community";
      repo = "haumea";
    };
  };
}
