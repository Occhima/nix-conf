{ ... }:
{
  flake.modules.homeManager.beancount =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          beancount
          beancount-language-server

          #NOTE: broken
          # fava
        ];
      };
    };
}
