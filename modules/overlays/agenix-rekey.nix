# Re-export the agenix-rekey overlay on this flake.
{ inputs, ... }: {
  flake.overlays.agenix-rekey = inputs.agenix-rekey.overlays.default;
}
