{ ... }:
{
  occhima.zoxide.homeManager = (
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
