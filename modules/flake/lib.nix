{ inputs, ... }:
{
  # Custom helpers live under a namespace; the ordinary nixpkgs `lib` is
  # never shadowed. Module evaluations receive them as `lib.occhima` (see
  # the host builder and the standalone Home Manager wiring).
  flake.lib.occhima = import ../../lib { inherit (inputs.nixpkgs) lib; };
}
