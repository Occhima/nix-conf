{ inputs, ... }:
{
  nur = inputs.nur.overlays.default;
  deploy-rs = inputs.deploy-rs.overlay;
}
