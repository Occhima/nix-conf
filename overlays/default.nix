{ inputs, ... }:
{
  nur = inputs.nur.overlays.default;
  deploy-rs = inputs.deploy-rs.overlay;
  colmena = inputs.colmena.overlay;
  agenix = inputs.agenix.overlays.default;
}
