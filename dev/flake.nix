{
  description = "Dependencies for my nixos config devenv";

  inputs = {

    nixpkgs = { url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
    git-hooks = {
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
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };

  };

  outputs = _: { };
}
