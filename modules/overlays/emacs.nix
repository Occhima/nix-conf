# Re-export the emacs-overlay overlay on this flake.
{ inputs, ... }:
{
  flake.overlays.emacs-overlay = inputs.emacs-overlay.overlays.default;
}
