# Re-export the agenix overlay on this flake.
{ inputs, ... }:
{
  flake.overlays.agenix = inputs.agenix.overlays.default;
}
