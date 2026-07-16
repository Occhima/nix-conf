{ ... }:
{
  config.flake.modules.homeManager.zoxide = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.zoxide = {
          enable = true;
        };
      };
    }
  );
}
