{
  description = "My dendritic NixOS config";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
        ./flake/flake-module.nix
      ];
    };

  inputs = {
    # Sources
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
    };

    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };

    # ========= Utilities =========
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    import-tree = {
      type = "github";
      owner = "denful";
      repo = "import-tree";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Styling
    stylix = {
      type = "github";
      owner = "danth";
      repo = "stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Editor
    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
    };

    # Secure boot
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Deployment
    deploy-rs = {
      type = "github";
      owner = "serokell";
      repo = "deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      type = "github";
      owner = "nix-community";
      repo = "nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Overlays
    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    nix-on-droid = {
      type = "github";
      owner = "nix-community";
      repo = "nix-on-droid";
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

    caelestia-shell = {
      type = "github";
      owner = "caelestia-dots";
      repo = "shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
