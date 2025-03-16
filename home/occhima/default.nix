{ config, ... }:
{
  home = {
    username = "occhima";
    homeDirectory = "/home/${config.home.username}";
  };

  modules = {
    shell = {
      type = "zsh";
      prompt.type = "starship";
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
    };
  };
}
