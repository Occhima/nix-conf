{
  description = "My extra bloated NixOS config";

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        options,
        lib,
        pkgs,
        ...
      }:
      let
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
          inherit localFlake;
        };
      in
      {
        imports = [ flakeModule ];
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

    # nixpkgs-unstable = {
    #   type = "github";
    #   owner = "NixOS";
    #   repo = "nixpkgs";
    #   ref = "nixos-unstable";
    # };

    # ========= Utilities =========
    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
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

    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
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
      };
    };

    easy-hosts = {
      type = "github";
      owner = "tgirlcloud";
      repo = "easy-hosts";
    };

    # Sec (commented out)

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "nixpkgs";
      };
    };

    agenix-rekey = {
      type = "github";
      owner = "oddlama";
      repo = "agenix-rekey";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # For secure boot support
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # sops (commented out)
    # sops = {
    #   type = "github";
    #   owner = "Mic92";
    #   repo = "sops-nix";
    # };

    # Deployment tools
    deploy-rs = {
      type = "github";
      owner = "serokell";
      repo = "deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # https://github.com/search?q=colmena&type=repositories
    # For now, Im using deploy-rs as reployment tool
    # colmena = {
    #   type = "github";
    #   owner = "zhaofengli";
    #   repo = "colmena";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #   };

    # };

    # Utility for importing modules
    haumea = {
      type = "github";
      owner = "nix-community";
      repo = "haumea";
    };

  };
}
