{ ... }:
{
  flake.modules.homeManager.podman =
    {
      config,
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
