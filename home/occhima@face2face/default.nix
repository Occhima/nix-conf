{
  home = {
    username = "occhima";
  };

  modules = {
    shell = {
      enable = true;
      type = "zsh";
      prompt.type = "starship";
      cli = {
        enable = true;
        passwordStore = {
          enable = true;
          secretService = true;
        };
      };
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
    };

    editor = {
      neovim = {
        enable = true;
      };
    };

  };
}
