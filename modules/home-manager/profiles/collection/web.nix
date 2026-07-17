{ ... }:
{
  config.occhima.web.homeManager = (
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
    }
  );
}
