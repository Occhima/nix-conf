{ inputs, ... }:
let
  overlays = with inputs; {
    nur = nur.overlays.default;
    deploy-rs = deploy-rs.overlays.default;
    agenix = agenix.overlays.default;
    agenix-rekey = agenix-rekey.overlays.default;
    emacs-overlay = emacs-overlay.overlays.default;
    # unstable-packages = final: _prev: {
    #   unstable = import nixpkgs-unstable {
    #     inherit (final) system config;
    #     overlays = [
    #       (_final: prev: { gopls = prev.gopls.override { buildGoModule = prev.buildGo123Module; }; })
    #     ];
    #   };
    # };
    nyxt-overlay = import ./pkgs/nyxt-electron.nix;
  };

in
{
  flake.overlays = overlays;
}
