{
  flake.modules.homeManager.eza = {
    config = {
      programs.eza = {
        enable = true;
        icons = "auto";
        # enableAliases = true;

        extraOptions = [
          "--group"
          "--header"
          "--group-directories-first"
          "--time-style=long-iso"
        ];
      };

      # Additional aliases
      home.shellAliases = {
        l = "eza -l";
        la = "eza -la";
        lt = "eza --tree";
        ll = "eza -la --git";
      };
    };
  };
}
