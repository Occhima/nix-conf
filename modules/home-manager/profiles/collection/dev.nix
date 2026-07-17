{ ... }:
{
  config.occhima.dev.homeManager = (
    {
      pkgs,
      config,
      ...
    }:
    {
      config = {
        home = {
          packages = [
            # FIXME: Broken
            # pkgs.devenv
            pkgs.comma
            pkgs.hyperfine
          ];
        };
      };
    }
  );
}
