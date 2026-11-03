{
  flake.modules.homeManager.lazygit =
    { lib, ... }:
    {
      config = {
        programs.lazygit = {
          enable = true;
          settings = {
            gui.theme = {
              lightTheme = false;
              selectedLineBgColor = lib.mkAfter [ "default" ];
            };
          };
        };
      };
    };
}
