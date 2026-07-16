{ ... }:
{
  config.flake.modules.homeManager.navi = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.navi = {
          enable = true;
        };
      };
    }
  );
}
