{
  flake.modules.homeManager.gh =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        programs.gh = {
          enable = true;

          extensions = [
            pkgs.gh-eco
            pkgs.gh-cal
          ];

          settings = {
            git_protocol = "ssh";
            prompt = "enabled";
            pager = "less";
          };
        };
      };
    };
}
