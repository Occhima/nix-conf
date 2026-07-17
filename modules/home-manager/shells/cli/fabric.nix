{ ... }:
{
  occhima.fabric.homeManager = (
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
