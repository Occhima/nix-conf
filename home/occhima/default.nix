{
  home = {
    username = "occhima";
  };

  modules = {
    shell = {
      enable = true;
      type = "zsh";
      prompt.type = "starship";
      cli.enable = true;
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
    };

    # theme = {}
  };
}
