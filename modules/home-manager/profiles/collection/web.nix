{ ... }:
{
  flake.modules.homeManager.web =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          pastel
          postman
        ];
      };
    };
}
