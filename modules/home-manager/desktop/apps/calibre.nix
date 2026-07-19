{
  flake.modules.homeManager.calibre =
    {
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
