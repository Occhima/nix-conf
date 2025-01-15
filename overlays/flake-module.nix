{ inputs, ... }:

{

  imports = [
    # use easyOverlay for CREATING overlays
    # inputs.nixpkgs.inputs.flake-parts.flakeModules.easyOverlay
  ];

  flake.overlays = import ./. { inherit inputs; };

}
