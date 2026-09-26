# Nyxt: upstream AppImage package and runnable app.
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.nyxt = pkgs.callPackage ./_nyxt/package.nix { };

      apps.nyxt = {
        type = "app";
        program = "${self'.packages.nyxt}/bin/nyxt";
        meta.description = "Nyxt browser (upstream AppImage)";
      };
    };
}
