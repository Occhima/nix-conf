# Nyxt: upstream AppImage package, master build (nyxt-dev) and runnable apps.
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.nyxt = pkgs.callPackage ./_nyxt/package.nix { };
      packages.nyxt-dev = pkgs.callPackage ./_nyxt-dev/package.nix { };

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
