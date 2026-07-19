{
  flake.modules.homeManager.ripgrep =
    {
      ...
    }:
    {
      config = {
        programs.ripgrep = {
          enable = true;
          arguments = [
            "--smart-case"
            "--hidden"
            "--glob=!.git/*"
          ];
        };

        # Additional aliases
        home.shellAliases = {
          rg = "rg --pretty";
          rgf = "rg --files | rg";
        };
      };
    };
}
