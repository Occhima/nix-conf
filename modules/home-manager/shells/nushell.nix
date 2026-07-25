{
  flake.modules.homeManager.shell-nushell = { pkgs, ... }: {
    config = {
      programs.nushell = {
        enable = true;
        settings = {
          show_banner = false;
          completions = {
            case_sensitive = false;
            quick = true;
            partial = true;
            algorithm = "fuzzy";
          };
        };
        plugins = with pkgs.nushellPlugins; [
          formats
          gstat
          query
          # net
          highlight
          polars
        ];
      };
    };
  };
}
