{
  description = "Dependencies for my nixos config devenv";

  inputs = {

    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Nix Format.
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    # nix-inspect = {
    #   url = "github:bluskript/nix-inspect";
    # };

    # TODO: snapshot testing
    # namaka = {
    #   url = "github:nix-community/namaka";
    #   inputs = {
    #     haumea.follows = "haumea";
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };

    # omnix = {
    #   url = "github:juspay/omnix";
    # };

    # Does not work anymore, I must hav emade something stupid
    # just-flake = {
    #   url = "github:juspay/just-flake";
    # };

    nix-unit = {
      url = "github:nix-community/nix-unit";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # for the dev shell
    agenix-shell = {
      url = "github:aciceri/agenix-shell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

  };

  outputs = _: { };
}
