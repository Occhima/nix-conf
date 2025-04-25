{ ... }:
{
  perSystem =
    {
      self',
      ...
    }:
    {
      apps = {
        nyxt-unstable = {
          type = "app";
          program = "${self'.packages.nyxt-unstable}/bin/nyxt";
        };
      };
    };
}
