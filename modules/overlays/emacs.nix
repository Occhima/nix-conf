# Re-export the emacs-overlay overlay on this flake and apply it to the internal package sets.
{ inputs, ... }: {
  flake-file.inputs.emacs-overlay = {
    url = "github:nix-community/emacs-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.overlays.emacs-overlay = inputs.emacs-overlay.overlays.default;
  nixpkgs.internalOverlays = [ inputs.emacs-overlay.overlays.default ];
}
