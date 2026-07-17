{ ... }:
{
  flake.modules.homeManager.lazygit = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.lazygit = {
          enable = true;
          settings = {
            gui.theme = {
              lightTheme = false;
              selectedLineBgColor = [ "default" ];
            };
          };
        };
      };
    }
  );
}
