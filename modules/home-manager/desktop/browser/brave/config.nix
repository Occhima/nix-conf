{ ... }:
{
  flake.modules.homeManager.browser-brave = (
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
