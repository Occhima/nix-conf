{ ... }:
{
  occhima.navi.homeManager = (
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
