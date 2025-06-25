{ ... }:
{
  perSystem =
    {
      self',
      ...
    }:
    {
      apps = {
        nyxt-source = {
          type = "app";
          program = "${self'.packages.nyxt-source}/bin/nyxt";
          meta.description = ''. '';
        };
      };
    };
}
