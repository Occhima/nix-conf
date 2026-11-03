# Standalone Home Manager output for occhima (non-NixOS machines), generated
# by Den from the same `occhima` user aspect. Uses the shared nixpkgs policy
# and the explicit internal overlay list; no fabricated osConfig — modules
# take `osConfig ? { }` and degrade intentionally.
{
  config,
  inputs,
  ...
}:
{
  den.homes.aarch64-linux.phone-home = {
    userName = "nix-on-droid";
    pkgs = import inputs.nixpkgs {
      system = "aarch64-linux";
      config = config.flake.lib.custom.nixpkgsConfig;
    };
  };

  den.homes.x86_64-linux.occhima = {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config = config.flake.lib.custom.nixpkgsConfig;
      overlays = [
        config.flake.overlays.emacs-overlay
        config.flake.overlays.nur
      ];
    };
  };
}
