{ inputs, ... }:
let
  inherit (inputs) nixpkgs;
  overlays = {
    nur = inputs.nur.overlays.default;
    deploy-rs = inputs.deploy-rs.overlay;
    # colmena = inputs.colmena.overlay;
    agenix = inputs.agenix.overlays.default;
    agenix-rekey = inputs.agenix-rekey.overlays.default;
    emacs-overlay = inputs.emacs-overlay.overlays.default;
  };

in
{
  # FIXME: Make it global!
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
          allowBroken = false;
          permittedInsecurePackages = [ ];
          allowUnsupportedSystem = true;
        };
      };
    };
  flake.overlays = overlays;

}
