{
  description = "Dependencies for my nixos config devenv";

  inputs = {

    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nix-search-tv = {
      type = "github";
      owner = "3timeslazy";
      repo = "nix-search-tv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      type = "github";
      owner = "cachix";
      repo = "git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Format.
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: snapshot testing
    # namaka = {
    #   type = "github";
    #   owner = "nix-community";
    #   repo = "namaka";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };

    # Does not work anymore, I must have made something stupid
    just-flake = {
      type = "github";
      owner = "juspay";
      repo = "just-flake";
    };

    nix-unit = {
      type = "github";
      owner = "nix-community";
      repo = "nix-unit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mkdocs-flake = {
    #   type = "github";
    #   owner = "applicative-systems";
    #   repo = "mkdocs-flake";
    # };

  };

  outputs = _: { };
}
