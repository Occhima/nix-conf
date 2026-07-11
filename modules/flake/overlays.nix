{ inputs, ... }:
{
  flake.overlays = {
    nur = inputs.nur.overlays.default;
    deploy-rs = inputs.deploy-rs.overlays.default;
    agenix = inputs.agenix.overlays.default;
    agenix-rekey = inputs.agenix-rekey.overlays.default;
    emacs-overlay = inputs.emacs-overlay.overlays.default;
    nyxt-overlay = import ../../overlays/nyxt-electron.nix;
  };
}
