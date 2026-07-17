{ ... }:
{
  config.occhima.calibre.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = [
          pkgs.calibre
        ];
      };
    }
  );
}
