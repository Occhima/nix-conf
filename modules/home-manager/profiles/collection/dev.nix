{
  flake.modules.homeManager.dev =
    {
      pkgs,
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
    };
}
