{ ... }:
{
  config.flake.modules.homeManager.dev = (
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
