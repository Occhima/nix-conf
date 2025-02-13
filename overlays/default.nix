{ inputs, ... }:
with inputs;
{
  nur = nur.overlays.default;
  deploy-rs = deploy-rs.overlay;
  # colmena = inputs.colmena.overlay;
  agenix = agenix.overlays.default;
  agenix-rekey = agenix-rekey.overlays.default;
}
