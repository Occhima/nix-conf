{
  flake.modules.homeManager.jq = { pkgs, ... }: {
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
  };
}
