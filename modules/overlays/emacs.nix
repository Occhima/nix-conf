# Re-export the emacs-overlay overlay on this flake.
{ inputs, ... }: {
  flake-file.inputs.emacs-overlay = {
    url = "github:nix-community/emacs-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.overlays.emacs-overlay = inputs.emacs-overlay.overlays.default;
}
