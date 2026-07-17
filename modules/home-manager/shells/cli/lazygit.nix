{ ... }:
{
  config.occhima.lazygit.homeManager = (
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
