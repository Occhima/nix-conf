{
  flake.modules.homeManager.navi =
    {
      ...
    }:
    {
      config = {
        programs.navi = {
          enable = true;
        };
      };
    };
}
