# Standalone Home Manager output for occhima (non-NixOS machines), generated
# by Den from the same `occhima` user aspect. Uses the shared nixpkgs policy
# and the explicit internal overlay list; no fabricated osConfig — modules
# take `osConfig ? { }` and degrade intentionally.
{ config, ... }:
let
  inherit (config.flake.lib.custom) mkPkgs;
in
{
  den.homes.aarch64-linux.phone-home = {
    userName = "nix-on-droid";
    pkgs = mkPkgs { system = "aarch64-linux"; };
  };

  den.homes.x86_64-linux.occhima = {
    pkgs = mkPkgs {
      system = "x86_64-linux";
      overlays = [
        config.flake.overlays.emacs-overlay
        config.flake.overlays.nur
      ];
    };
  };
}
