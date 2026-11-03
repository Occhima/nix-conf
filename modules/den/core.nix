{ inputs, ... }:
{
  flake-file.inputs.den.url = "github:denful/den";

  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.den.flakeModule ];
}
