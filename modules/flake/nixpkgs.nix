# Package set used for `perSystem` outputs (packages, apps, dev tooling).
# NixOS hosts configure their own nixpkgs through the `nixpkgs-config`
# aspect; this instance only backs the flake-level outputs.
{
  config,
  inputs,
  ...
}:
{
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = config.flake.lib.custom.nixpkgsConfig;
      overlays = [
        config.flake.overlays.emacs-overlay
        config.flake.overlays.nur
      ];
    };
  };
}
