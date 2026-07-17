{ ... }:
{
  flake.modules.homeManager.fabric = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.fabric-ai = {
          enable = true;
          enableYtAlias = true;
        };
      };
    }
  );
}
