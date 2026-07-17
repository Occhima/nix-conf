{ ... }:
{
  occhima.browser-brave.homeManager = (
    {
      pkgs,
      config,
      ...
    }:
    {
      config = {
        home.packages = [ pkgs.brave ];
      };
    }
  );
}
