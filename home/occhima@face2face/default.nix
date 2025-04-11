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
      dropbox.enable = true;
    };

    editor = {
      neovim = {
        enable = true;
      };
    };

  };
}
