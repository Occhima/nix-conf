{ ... }:
{
  config.flake.modules.homeManager.jq = (
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = [
          pkgs.jq-lsp
          pkgs.jql
        ];
        programs.jq = {
          enable = true;
        };
        programs.jqp = {
          enable = true;
        };
      };
    }
  );
}
