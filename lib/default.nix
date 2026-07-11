# Custom library, exposed to modules as `lib.occhima` and to the flake as
# `self.lib.occhima`. Keep it small and domain-specific.
{ lib }:
import ./discovery.nix { inherit lib; }
// import ./helpers.nix { inherit lib; }
// import ./themes.nix { inherit lib; }
