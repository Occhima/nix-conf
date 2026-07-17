{ ... }:
{
  occhima.bat.homeManager = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.bat = {
          enable = true;

          config = {
            pager = "less -FR";
            color = "always";
            style = "plain";
            # theme = "Catppuccin-mocha";
          };

          # themes = {
          # };
        };

        # Alias cat to bat
        home.shellAliases = {
          cat = "bat";
        };
      };
    }
  );
}
