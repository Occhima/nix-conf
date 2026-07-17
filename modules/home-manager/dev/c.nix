{ ... }:
{
  occhima.c.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          gcc
        ];
      };
    }
  );
}
