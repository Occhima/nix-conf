# Re-export the nur overlay on this flake.
{ inputs, ... }: {
  flake-file.inputs.nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.overlays.nur = inputs.nur.overlays.default;
}
