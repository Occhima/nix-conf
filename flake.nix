{
  description = "My extra-bloated NixOS config";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # Structural top-level modules are discovered automatically; see
      # modules/flake/default.nix for the rules.
      imports = [ ./modules/flake ];
    };

  inputs = {
    # Sources
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      # ref = "nixos-25.05"; # going back to unstable
    };
    caelestia-shell = {
      type = "github";
      owner = "caelestia-dots";
      repo = "shell";
      inputs.nixpkgs.follows = "nixpkgs";
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
      # ref = "release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
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

    # Sec (commented out)

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
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

    stylix = {
      type = "github";
      owner = "danth";
      repo = "stylix";
      # ref = "release-25.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # home-manager.follows = "nixpkgs";
      };
    };

    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
      # inputs = {
      #   nixpkgs.follows = "nixpkgs";
      # };
    };

    # For secure boot support
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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

    # Emacs overlay
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flatpak management
    flatpaks = {
      type = "github";
      owner = "gmodena";
      repo = "nix-flatpak";
    };

    spicetify-nix = {
      type = "github";
      owner = "Gerg-L";
      repo = "spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schizofox = {
      type = "github";
      owner = "schizofox";
      repo = "schizofox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      type = "github";
      owner = "astro";
      repo = "microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    niri = {
      type = "github";
      owner = "sodiboo";
      repo = "niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      type = "github";
      owner = "0xc000022070";
      repo = "zen-browser-flake";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };
}
