{
  flake.modules.homeManager.podman =
    {
      ...
    }:
    {
      config = {
        services.podman = {
          enable = true;
          enableTypeChecks = true;
        };
      };
    };
}
