# Nyxt: source build package, runnable app, and the nyxt-electron overlay
# — one feature, several outputs.
{ ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages.nyxt-source = pkgs.callPackage ../../packages/nyxt/package.nix { };

      apps.nyxt-source = {
        type = "app";
        program = "${self'.packages.nyxt-source}/bin/nyxt";
        meta.description = "Nyxt browser built from source";
      };
    };

  flake.overlays.nyxt-overlay = import ../../packages/nyxt/electron-overlay.nix;
}
