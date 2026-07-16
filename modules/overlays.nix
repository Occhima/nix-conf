{ inputs, ... }:
{
  flake.overlays = with inputs; {
    nur = nur.overlays.default;
    deploy-rs = deploy-rs.overlays.default;
    agenix = agenix.overlays.default;
    agenix-rekey = agenix-rekey.overlays.default;
    emacs-overlay = emacs-overlay.overlays.default;
    nyxt-overlay = import ../flake/overlays/pkgs/nyxt-electron.nix;
  };
}
