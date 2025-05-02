{ inputs, ... }:
let
  overlays = {
    nur = inputs.nur.overlays.default;
    deploy-rs = inputs.deploy-rs.overlay;
    agenix = inputs.agenix.overlays.default;
    agenix-rekey = inputs.agenix-rekey.overlays.default;
    emacs-overlay = inputs.emacs-overlay.overlays.default;
    unstable-packages = final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system;
        config.allowUnfree = true;
        overlays = [
          (_final: prev: { gopls = prev.gopls.override { buildGoModule = prev.buildGo123Module; }; })
        ];
      };
    };
  };

in
{
  flake.overlays = overlays;
}
