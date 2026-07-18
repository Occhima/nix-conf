{ ... }:
{
  flake.modules.homeManager.python =
    {
      config,
      ...
    }:
    {
      config = {
        programs.uv = {
          enable = true;
          settings = {
            index-strategy = "first-index";
            compile-bytecode = true;
            exclude-newer = "7 days";
          };
        };

        programs.pyenv = {
          enable = true;
          rootDirectory = "${config.xdg.configHome}/pyenv";
        };
      };
    };
}
