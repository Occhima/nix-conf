# Nyxt: master build (nyxt-dev) and runnable app.
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
      packages.nyxt-dev = pkgs.callPackage ./_nyxt-dev/package.nix { src = inputs.nyxt-src; };

      apps.nyxt-dev = {
        type = "app";
        program = "${self'.packages.nyxt-dev}/bin/nyxt";
        meta.description = "Nyxt browser built from master";
      };
    };
}
