# Re-export the nur overlay on this flake and apply it to the internal package sets.
{ inputs, ... }: {
  flake-file.inputs.nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.overlays.nur = inputs.nur.overlays.default;
  nixpkgs.internalOverlays = [ inputs.nur.overlays.default ];
}
