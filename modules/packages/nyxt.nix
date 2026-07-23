# Nyxt: source build package and runnable app.
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages.nyxt-source = pkgs.callPackage ./_nyxt/package.nix { };

      apps.nyxt-source = {
        type = "app";
        program = "${self'.packages.nyxt-source}/bin/nyxt";
        meta.description = "Nyxt browser built from source";
      };
    };
}
