{
  flake.modules.homeManager.calibre =
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
    };
}
