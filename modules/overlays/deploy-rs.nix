# Re-export the deploy-rs overlay on this flake.
{ inputs, ... }:
{
  flake.overlays.deploy-rs = inputs.deploy-rs.overlays.default;
}
