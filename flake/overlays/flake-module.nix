{ inputs, ... }:
let
  overlays = with inputs; {
    nur = nur.overlays.default;
    deploy-rs = deploy-rs.overlay;
    agenix = agenix.overlays.default;
    agenix-rekey = agenix-rekey.overlays.default;
    emacs-overlay = emacs-overlay.overlays.default;
    nixgl = nixgl.overlay;
    unstable-packages = final: _prev: {
      unstable = import nixpkgs-unstable {
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
