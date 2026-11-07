# Nyxt: upstream AppImage package, master build (nyxt-dev) and runnable apps.
{ inputs, ... }:
{
  flake-file.inputs.nyxt-src = {
    url = "github:atlas-engineer/nyxt";
    flake = false;
  };

  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.nyxt = pkgs.callPackage ./_nyxt/package.nix { };
      packages.nyxt-dev = pkgs.callPackage ./_nyxt-dev/package.nix { src = inputs.nyxt-src; };

      apps.nyxt = {
        type = "app";
        program = "${self'.packages.nyxt}/bin/nyxt";
        meta.description = "Nyxt browser (upstream AppImage)";
      };

      apps.nyxt-dev = {
        type = "app";
        program = "${self'.packages.nyxt-dev}/bin/nyxt";
        meta.description = "Nyxt browser built from master";
      };
    };
}
