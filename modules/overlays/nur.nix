# Re-export the nur overlay on this flake.
{ inputs, ... }:
{
  flake.overlays.nur = inputs.nur.overlays.default;
}
