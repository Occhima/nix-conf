{ ... }:
{
  occhima.podman.homeManager = (
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
    }
  );
}
